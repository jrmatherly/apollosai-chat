import { S3Client } from '@aws-sdk/client-s3';
import { logger } from '@librechat/data-schemas';
import { isEnabled } from '~/utils/common';

import type { S3ClientConfig } from '@aws-sdk/client-s3';

let s3: S3Client | null = null;
let s3Presign: S3Client | null = null;

function buildS3BaseConfig(): S3ClientConfig | null {
  const region = process.env.AWS_REGION;
  if (!region) {
    return null;
  }

  const config: S3ClientConfig = {
    region,
    ...(isEnabled(process.env.AWS_FORCE_PATH_STYLE) ? { forcePathStyle: true } : {}),
  };

  const accessKeyId = process.env.AWS_ACCESS_KEY_ID;
  const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY;
  if (accessKeyId && secretAccessKey) {
    config.credentials = { accessKeyId, secretAccessKey };
  }

  return config;
}

/**
 * Initializes and returns an instance of the AWS S3 client.
 *
 * If AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are provided, they will be used.
 * Otherwise, the AWS SDK's default credentials chain (including IRSA) is used.
 *
 * If AWS_ENDPOINT_URL is provided, it will be used as the endpoint.
 *
 * @returns An instance of S3Client if the region is provided; otherwise, null.
 */
export const initializeS3 = (): S3Client | null => {
  if (s3) {
    return s3;
  }

  const config = buildS3BaseConfig();
  if (!config) {
    logger.error('[initializeS3] AWS_REGION is not set. Cannot initialize S3.');
    return null;
  }

  const endpoint = process.env.AWS_ENDPOINT_URL;
  if (endpoint) {
    config.endpoint = endpoint;
  }

  s3 = new S3Client(config);
  if (config.credentials) {
    logger.info('[initializeS3] S3 initialized with provided credentials.');
  } else {
    logger.info('[initializeS3] S3 initialized using default credentials (IRSA).');
  }

  return s3;
};

/**
 * Initializes and returns an S3 client configured for presigned URL generation.
 *
 * Uses AWS_PRESIGN_ENDPOINT_URL when set, so presigned URLs contain a
 * browser-reachable hostname instead of a Docker-internal one.
 * Falls back to the standard S3 client when the env var is not configured.
 */
export const initializeS3Presign = (): S3Client | null => {
  if (s3Presign) {
    return s3Presign;
  }

  const presignEndpoint = process.env.AWS_PRESIGN_ENDPOINT_URL;
  if (!presignEndpoint) {
    return initializeS3();
  }

  const config = buildS3BaseConfig();
  if (!config) {
    logger.error(
      '[initializeS3Presign] AWS_REGION is not set. Cannot initialize S3 presign client.',
    );
    return null;
  }

  config.endpoint = presignEndpoint;
  s3Presign = new S3Client(config);
  logger.info(
    `[initializeS3Presign] S3 presign client initialized with endpoint: ${presignEndpoint}`,
  );
  return s3Presign;
};
