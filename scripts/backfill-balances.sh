#!/usr/bin/env bash
# Backfill balance records for users missing them (or with tokenCredits: 0).
#
# Problem: Users created before balance enforcement was enabled in librechat.yaml
# have no balance record (or tokenCredits: 0), causing "Insufficient Funds" errors
# when balance.enabled is set to true.
#
# This script upserts balance records for all affected users using the intended
# "track-only" configuration (10M starting tokens, daily 10M auto-refill).
# It is idempotent — safe to run multiple times.
#
# Usage:
#   # Via docker (connects to the MongoDB container directly):
#   docker exec -i chat-mongodb mongosh --quiet --norc LibreChat < scripts/backfill-balances.sh
#
#   # Or with a remote URI:
#   mongosh --quiet --norc "mongodb://localhost:27017/LibreChat" < scripts/backfill-balances.sh
#
#   # Dry run (preview only, no writes):
#   DRY_RUN=1 bash scripts/backfill-balances.sh
#
# The mongosh JavaScript is embedded below via heredoc.

set -euo pipefail

MONGO_URI="${MONGO_URI:-mongodb://mongodb:27017/LibreChat}"
MONGO_CONTAINER="${MONGO_CONTAINER:-chat-mongodb}"
DRY_RUN="${DRY_RUN:-}"

MONGOSH_SCRIPT='
const TOKEN_CREDITS = 10000000;
const BALANCE_CONFIG = {
  tokenCredits: TOKEN_CREDITS,
  autoRefillEnabled: true,
  refillIntervalValue: 1,
  refillIntervalUnit: "days",
  refillAmount: TOKEN_CREDITS,
  lastRefill: new Date(),
};

const DRY_RUN = !!process.env.DRY_RUN;

if (DRY_RUN) {
  print("*** DRY RUN — no changes will be written ***\n");
}

const users = db.users.find({}, { _id: 1, email: 1, username: 1, name: 1 }).toArray();
print(`Found ${users.length} total users.\n`);

const balances = db.balances.find({}).toArray();
const balanceMap = {};
balances.forEach(b => { balanceMap[b.user.toString()] = b; });

let created = 0;
let updated = 0;
let skipped = 0;

users.forEach(user => {
  const uid = user._id.toString();
  const label = user.username || user.email || user.name || uid;
  const existing = balanceMap[uid];

  if (!existing) {
    print(`  [CREATE] ${label} — no balance record`);
    if (!DRY_RUN) {
      db.balances.insertOne({ user: user._id, ...BALANCE_CONFIG });
    }
    created++;
  } else if (existing.tokenCredits === 0) {
    print(`  [UPDATE] ${label} — tokenCredits: 0 -> ${TOKEN_CREDITS}`);
    if (!DRY_RUN) {
      db.balances.updateOne({ _id: existing._id }, { $set: BALANCE_CONFIG });
    }
    updated++;
  } else {
    skipped++;
  }
});

print(`\n--- Summary ${DRY_RUN ? "(DRY RUN)" : ""} ---`);
print(`  Created: ${created}`);
print(`  Updated: ${updated} (tokenCredits was 0)`);
print(`  Skipped: ${skipped} (already had balance > 0)`);
print(`  Total:   ${users.length}`);
print("\nDone.");
'

if command -v mongosh &>/dev/null; then
  echo "Running locally with mongosh..."
  echo "$MONGOSH_SCRIPT" | DRY_RUN="$DRY_RUN" mongosh --quiet --norc "$MONGO_URI"
elif docker ps --format '{{.Names}}' | grep -q "^${MONGO_CONTAINER}$"; then
  echo "Running via docker exec on ${MONGO_CONTAINER}..."
  echo "$MONGOSH_SCRIPT" | docker exec -i -e DRY_RUN="$DRY_RUN" "$MONGO_CONTAINER" mongosh --quiet --norc LibreChat
else
  echo "Error: mongosh not found locally and container '${MONGO_CONTAINER}' is not running." >&2
  exit 1
fi
