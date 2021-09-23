const path = require("path");
const glob = require("glob");

const MiniCssExtractPlugin        = require("mini-css-extract-plugin");
const LiveReloadPlugin            = require('webpack-livereload-plugin');
const BrowserSyncPlugin           = require('browser-sync-webpack-plugin');
const FriendlyErrorsWebpackPlugin = require('friendly-errors-webpack-plugin');

module.exports = (env, argv) => {

    var config = {

        mode: "production",

        entry: [
            path.resolve(__dirname, "scripts/builder.coffee"),
            path.resolve(__dirname, "styles/builder.sass"),
        ].concat(glob.sync('./views/**/[^_]*.pug')),

        output: {
            path: path.resolve(__dirname, "build"),
            filename: "js/bundle.js",
        },
        
        performance: {
            hints: false,
            maxEntrypointSize: 512000,
            maxAssetSize: 512000
        },

        plugins: [
            
            new MiniCssExtractPlugin({
                filename: "css/bundle.css",
                chunkFilename: "[name].css"
            }),

            // new LiveReloadPlugin({
            //     appendScriptTag: true,
            //     ignore: /\.js$|\.map$|\.html|\.json$$/
            // }),

            new BrowserSyncPlugin({
                port: 3000,
                host: 'localhost',
                proxy: "http://localhost/",
                ignore: [
                    "**/*.js", "**/*.map", "**/*.html", "**/*.json"
                ],
                files: [
                    {
                        match: [ "**/*.pug" ],
                        fn: function(event, file) {
                            if (event === "change") require("browser-sync").get("bs-webpack-plugin").reload();
                        }
                    }
                ]
            }, { reload: false }),

            new FriendlyErrorsWebpackPlugin(),

        ],

        module: {
            rules: [
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
                                : "http://localhost/_lab/threejs-journey/"
                        } } }
                    ]
                },
                {
                    test: /\.coffee$/,
                    exclude: /node_modules/,
                    loader: 'coffee-loader',
                },
                {
                    test: /\.sass$/i,
                    exclude: /node_modules/,
                    use: [
                        { loader: MiniCssExtractPlugin.loader },
                        { loader: "css-loader", options: { url: false, sourceMap: true, } },
                        // { loader: "postcss-loader" },
                        { loader: "sass-loader", options: { sourceMap: true, } }
                    ],
                },
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
    }

    return config;

}