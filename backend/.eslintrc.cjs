module.exports = {
  root: true,
  env: {
    node: true,
    es2022: true,
  },
  parserOptions: {
    sourceType: 'module',
    ecmaVersion: 'latest',
  },
  plugins: ['import'],
  extends: ['eslint:recommended', 'plugin:import/recommended', 'prettier'],
  settings: {
    'import/resolver': {
      node: {
        extensions: ['.js'],
      },
    },
  },
  rules: {
    'import/order': [
      'error',
      {
        alphabetize: { order: 'asc', caseInsensitive: true },
        'newlines-between': 'always',
      },
    ],
    'import/no-named-as-default-member': 'off',
    'import/namespace': 'off',
    'no-unused-vars': [
      'error',
      { argsIgnorePattern: '^_' },
    ],
    'no-console': [
      'error',
      { allow: ['info', 'warn', 'error'] },
    ],
  },
};

