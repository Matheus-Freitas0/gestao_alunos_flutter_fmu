import HttpError from '../errors/http-error.js';

export const errorHandler = (error, _req, res, _next) => {
  if (error instanceof HttpError) {
    res.status(error.statusCode).json({ message: error.message });
    return;
  }

  console.error('[UnhandledError]', error);
  res.status(500).json({ message: 'Internal server error' });
};

