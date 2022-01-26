/* eslint-disable quote-props */

module.exports = {
  env: {
    browser: true,
    commonjs: true,
    es2021: true,
  },
  extends: ['google'],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    allowImportExportEverywhere: true,
  },
  rules: {
    indent: 'off',
    'space-before-function-paren': 'off',
    'object-curly-spacing': ['error', 'always'],
    'linebreak-style': 'off',
    'max-len': 'off',
    'new-cap': 'off',
    'spaced-comment': ['error', 'always', { 'exceptions': ['-', '+'] }],
  },
};
