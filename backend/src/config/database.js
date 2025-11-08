import { createPool } from 'mysql2/promise';

import env from './env.js';

let pool = null;

export const getDatabasePool = () => {
  if (!pool) {
    pool = createPool({
      host: env.mysql.host,
      port: env.mysql.port,
      user: env.mysql.user,
      password: env.mysql.password,
      database: env.mysql.database,
      waitForConnections: true,
      connectionLimit: env.mysql.connectionLimit,
      queueLimit: 0,
    });
  }

  return pool;
};

export const closeDatabasePool = async () => {
  if (pool) {
    await pool.end();
    pool = null;
  }
};
