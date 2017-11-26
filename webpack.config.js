module.exports = {
    entry: "./js/entry.js",
    output: {
        path: __dirname,
        filename: "build/bundle.js"
    },
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: {
            loader: 'elm-webpack-loader',
            options: {
              cwd: __dirname + '/elm'
            }
          }
      },
      {
        test: /\.css$/,
        use: [ 'style-loader', 'css-loader' ]
      }
    ]

    },
    devServer: {
      port: 8008
    },
};
