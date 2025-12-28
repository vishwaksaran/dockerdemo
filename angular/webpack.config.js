const path = require('path');

module.exports = {
  // Legacy Webpack 2/3 config dump
  entry: './src/main.ts',
  output: {
    path: path.resolve(__dirname, '../dist/angular'),
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: 'awesome-typescript-loader'
      },
      {
        test: /\.scss$/,
        use: ['style-loader', 'css-loader', 'sass-loader'] // This will blow up on Node 16 with old node-sass
      }
    ]
  }
};
