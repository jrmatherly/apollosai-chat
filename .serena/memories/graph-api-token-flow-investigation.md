# Graph API Token Acquisition Flow - Complete Investigation

## 1. ROUTE DEFINITION
**File:** `/Users/jason/dev/ai-stack/LibreChat/api/server/routes/auth.js` (Line 73)
```javascript
router.get('/graph-token', middleware.requireJwtAuth, graphTokenController);
```
- **Route:** GET /api/auth/graph-token
- **Middleware:** requireJwtAuth (custom middleware that switches between JWT/OpenID strategies)
- **Handler:** graphTokenController

## 2. AUTHENTICATION MIDDLEWARE FLOW
**File:** `/Users/jason/dev/ai-stack/LibreChat/api/server/middleware/requireJwtAuth.js`
- Reads `token_provider` cookie
- If token_provider === 'openid' AND OPENID_REUSE_TOKENS enabled → uses 'openidJwt' strategy
- Otherwise → uses 'jwt' strategy
- **Result:** Sets req.user with federatedTokens populated

## 3. OPENID JWT STRATEGY (Loads federatedTokens into req.user)
**File:** `/Users/jason/dev/ai-stack/LibreChat/api/strategies/openIdJwtStrategy.js` (Lines 84-104)

**Token Loading Order:**
1. Try to load from req.session.openidTokens (server-side session storage)
2. Fallback to cookies: openid_access_token, openid_id_token, refreshToken
3. If no accessToken found in above, use rawToken from Authorization header

**federatedTokens Object Construction (Lines 99-104):**
```javascript
user.federatedTokens = {
  access_token: accessToken || rawToken,      // Session or fallback to header
  id_token: idToken,                           // Session or cookie
  refresh_token: refreshToken,                 // Session or cookie
  expires_at: payload.exp,                     // From JWT payload
};
```

## 4. CONTROLLER - graphTokenController
**File:** `/Users/jason/dev/ai-stack/LibreChat/api/server/controllers/AuthController.js` (Lines 183-222)

**Flow:**
1. Validates req.user.openidId && req.user.provider === 'openid' (403 if missing)
2. Checks OPENID_REUSE_TOKENS enabled (403 if disabled)
3. Validates scopes query param present (400 if missing)
4. **CRITICAL:** Extracts accessToken from req.user.federatedTokens?.access_token (401 if missing)
5. Calls getGraphApiToken(req.user, accessToken, scopes)
6. Returns token response or 500 on error

## 5. SERVICE LAYER - GraphTokenService
**File:** `/Users/jason/dev/ai-stack/LibreChat/api/server/services/GraphTokenService.js`

**getGraphApiToken Signature (Line 15):**
```javascript
async function getGraphApiToken(user, accessToken, scopes, fromCache = true)
```

**Flow:**
1. Validates user.openidId (throws error if missing)
2. Validates accessToken provided (throws error if missing)
3. Validates scopes provided (throws error if missing)
4. Gets OpenID config via getOpenIdConfig()
5. **CRITICAL:** Calls OBO (On-Behalf-Of) exchange via openid-client.genericGrantRequest:
   ```javascript
   const grantResponse = await client.genericGrantRequest(
     config,
     'urn:ietf:params:oauth:grant-type:jwt-bearer',
     {
       scope: scopes,
       assertion: accessToken,  // This is the federated access token, NOT id_token
       requested_token_use: 'on_behalf_of',
     },
   );
   ```
6. Caches response with key `${user.openidId}:${scopes}`
7. Returns response object with access_token, token_type, expires_in, scope

## 6. OPENID STRATEGY - Initial Login (Token Storage)
**File:** `/Users/jason/dev/ai-stack/LibreChat/api/strategies/openidStrategy.js` (Lines 589-599)

**Returns from processOpenIDAuth:**
```javascript
return {
  ...user,
  tokenset,
  federatedTokens: {
    access_token: tokenset.access_token,
    id_token: tokenset.id_token,
    refresh_token: tokenset.refresh_token,
    expires_at: tokenset.expires_at,
  },
};
```

## 7. OAUTH HANDLER - Token Persistence
**File:** `/Users/jason/dev/ai-stack/LibreChat/api/server/controllers/auth/oauth.js` (Lines 59-68)

When OpenID user logs in:
1. Calls syncUserEntraGroupMemberships with req.user.tokenset.access_token
2. Calls setOpenIDAuthTokens(req.user.tokenset, req, res, req.user._id.toString())

## 8. AUTH SERVICE - Session Storage
**File:** `/Users/jason/dev/ai-stack/LibreChat/api/server/services/AuthService.js` (Lines 429-531)

**setOpenIDAuthTokens Function:**
- Stores accessToken, idToken, refreshToken in req.session.openidTokens (Lines 482-488)
- Falls back to cookies if no session (Lines 491-505)
- Sets token_provider='openid' cookie (Lines 508-513)
- Sets openid_user_id JWT cookie if OPENID_REUSE_TOKENS enabled (Lines 514-525)

## CONFIGURATION VARIABLES REQUIRED
- OPENID_CLIENT_ID
- OPENID_CLIENT_SECRET  
- OPENID_ISSUER
- OPENID_SCOPE
- OPENID_REUSE_TOKENS (must be enabled, checked in graphTokenController)
- OPENID_CALLBACK_URL
- SESSION_EXPIRY
- REFRESH_TOKEN_EXPIRY
- DOMAIN_SERVER
- DOMAIN_CLIENT

## ERROR SCENARIOS & MESSAGES
1. **403 "Microsoft Graph access requires Entra ID authentication"**
   - Missing req.user.openidId OR req.user.provider !== 'openid'

2. **403 "SharePoint integration requires OpenID token reuse to be enabled"**
   - OPENID_REUSE_TOKENS not enabled

3. **400 "Graph API scopes are required as query parameter"**
   - Missing scopes query param

4. **401 "No federated access token available for token exchange"**
   - req.user.federatedTokens?.access_token is missing/undefined

5. **500 "Failed to obtain Microsoft Graph token"**
   - getGraphApiToken throws error (OBO exchange failure)
   - Error message from GraphTokenService: "Graph token acquisition failed: {error.message}"

## RECENT REFACTORING (commit cca9d6322)
**Changes:** "refactor: graphTokenController to use federated access token for OBO assertion"
- Removed extraction of access token from Authorization header
- Now uses federatedTokens.access_token from user object
- This is the CRITICAL change that requires federatedTokens to be populated

## DATA FLOW SUMMARY
1. User logs in via OpenID → openidStrategy processes auth
2. federatedTokens attached to user object with accessToken, idToken, refreshToken
3. OAuth handler stores tokenset in session via setOpenIDAuthTokens
4. requireJwtAuth middleware routes to openIdJwt strategy
5. openIdJwt strategy loads tokens from session (or cookies as fallback)
6. openIdJwt strategy populates federatedTokens in req.user
7. graphTokenController validates and extracts federatedTokens.access_token
8. GraphTokenService performs OBO exchange using that accessToken
9. Returns Graph API access token

## KEY INSIGHT
The error "server responded with an error in the response body" from graphTokenService at line 80 indicates the OBO exchange (genericGrantRequest) failed. This happens when:
- accessToken parameter passed to OBO is invalid/expired
- OpenID config is not available
- Microsoft Graph OBO flow is not properly configured
- The OpenID provider doesn't support OBO with the provided accessToken scopes
