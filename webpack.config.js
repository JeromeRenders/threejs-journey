
// Utils
const project = require("./package.json")
const path    = require("path")
const glob    = require("glob")

// Plugins
const MiniCssExtractPlugin        = require("mini-css-extract-plugin")
const FriendlyErrorsWebpackPlugin = require('friendly-errors-webpack-plugin')
const LiveReloadPlugin            = require('webpack-livereload-plugin')
const BrowserSyncPlugin           = require('browser-sync-webpack-plugin')
const UglifyJsPlugin              = require('uglifyjs-webpack-plugin')
const CssMinimizerPlugin          = require("css-minimizer-webpack-plugin")


module.exports = (env, argv) => {

    var config = {

        mode: "production",

        entry: [
            path.resolve(__dirname, "scripts/builder.coffee"),
            path.resolve(__dirname, "styles/builder.sass"),
        ].concat(glob.sync('./views/**/[^_]*.pug')),

        output: {
            filename: "js/bundle.js",
            path: path.resolve(__dirname, "build"),
        },

        plugins: [

            new MiniCssExtractPlugin({
                filename: "css/bundle.css",
                chunkFilename: "[name].css"
            }),

            new FriendlyErrorsWebpackPlugin(),

            new LiveReloadPlugin({
                appendScriptTag: true,
                ignore: /\.js$|\.map$|\.html$/
            }),

            new BrowserSyncPlugin({
                proxy: "http://localhost/" + project.name
            }),

        ],

        module: {
            rules: [
                // Pug
                {
                    test: /\.pug$/,
                    use: [
                        "file-loader?name=../build/html/[name].html",
                        "extract-loader",
                        { loader : "html-loader", options: {
                            esModule: false,
                        } },
                        { loader: "pug-html-loader", options: {data: {
                            version: Date.now(),
                            baseurl: env.production
                                ? "http://localhost/_lab/threejs-journey/"
                                : "https://lab.jeromerenders.be/threejs-journey/"
                        } } }
                    ]
                },

                // Coffee
                {
                    test: /\.coffee$/,
                    exclude: /node_modules/,
                    loader: 'coffee-loader',
                },

                // Sass
                {
                    test: /\.sass$/i,
                    exclude: /node_modules/,
                    use: [
                        { loader: MiniCssExtractPlugin.loader },
                        { loader: "css-loader", options: { url: false, sourceMap: true, } },
                        { loader: "sass-loader", options: { sourceMap: true, } }
                    ],
                },

                // GLSL
                {
                    test: /\.(glsl|vs|fs|vert|frag)$/,
                    exclude: /node_modules/,
                    use: [
                        'raw-loader',
                        'glslify-loader'
                    ]
                },
            ],
        },

        optimization: {
            minimizer: [
                new UglifyJsPlugin(),
                new CssMinimizerPlugin()
            ],
        },

    }

    return config;

}