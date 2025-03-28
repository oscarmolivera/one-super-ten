const esbuild = require("esbuild");
const { sassPlugin } = require("esbuild-sass-plugin");

const args = process.argv.slice(2);
const watch = args.includes("--watch");

const options = {
  entryPoints: ["app/javascript/application.js"],
  bundle: true,
  sourcemap: true,
  format: "esm",
  outdir: "app/assets/builds",
  publicPath: "/assets",
  plugins: [
    sassPlugin()
  ], 
  loader: {
    '.js': 'jsx',
    '.css': 'css',
    '.png': 'file',
    '.jpg': 'file',
    '.svg': 'file',
    '.woff': 'file',
    '.woff2': 'file',
    '.eot': 'file',
    '.ttf': 'file'
  },
  external: [
    'fonts/materialdesignicons-webfont.woff2?v=2.0.46',
    'fonts/materialdesignicons-webfont.woff?v=2.0.46',
    'fonts/materialdesignicons-webfont.ttf?v=2.0.46',
    'fonts/materialdesignicons-webfont.svg?v=2.0.46#materialdesigniconsregular',
    'fonts/Simple-Line-Icons.eot?v=2.4.0',
    'fonts/Simple-Line-Icons.eot?v=2.4.0#iefix',
    'fonts/Simple-Line-Icons.woff2?v=2.4.0',
    'fonts/Simple-Line-Icons.ttf?v=2.4.0',
    'fonts/Simple-Line-Icons.woff?v=2.4.0',
    'fonts/Simple-Line-Icons.svg?v=2.4.0#simple-line-icons',
    'fonts/icomoon.eot?8vup1e',
    'fonts/icomoon.eot?8vup1e#iefix',
    'fonts/icomoon.ttf?8vup1e',
    'fonts/icomoon.woff?8vup1e',
    'fonts/icomoon.svg?8vup1e#icomoon',
    'cryptocoins.*',
    'icomoon.*',
    '../font/weathericons-regular-webfont.*',
    '../flags/1x1/*.svg',
    '../flags/4x3/*.svg',
    'fonts/materialdesignicons-webfont.eot?v=2.0.46',
    'fonts/materialdesignicons-webfont.eot?#iefix&v=2.0.46',
    'fonts/linea-ecommerce-10.svg#linea-ecommerce-10',
    'fonts/linea-music-10.eot',
    'fonts/linea-music-10.eot?#iefix',
    'fonts/linea-music-10.woff',
    'fonts/linea-music-10.ttf',
    'fonts/linea-music-10.svg#linea-music-10',
    'fonts/linea-software-10.eot',
    'fonts/linea-software-10.eot?#iefix',
    'fonts/linea-software-10.woff',
    'fonts/linea-software-10.ttf',
    'fonts/linea-software-10.svg#linea-software-10',
    'fonts/linea-weather-10.eot',
    'fonts/linea-weather-10.eot?#iefix',
    'fonts/linea-weather-10.woff',
    'fonts/linea-weather-10.ttf',
    'fonts/linea-weather-10.svg#linea-weather-10',
    'glyphicons-halflings-regular.eot',
    'glyphicons-halflings-regular.eot?#iefix',
    'glyphicons-halflings-regular.woff2',
    'glyphicons-halflings-regular.woff',
    'glyphicons-halflings-regular.ttf',
    'glyphicons-halflings-regular.svg#glyphicons_halflingsregular',
    'fonts/themify.woff',
    'fonts/themify.ttf',
    'fonts/themify.svg?-fvbane#themify',
    'fonts/linea-arrows-10.eot',
    'fonts/linea-arrows-10.eot?#iefix',
    'fonts/linea-arrows-10.woff',
    'fonts/linea-arrows-10.ttf',
    'fonts/linea-arrows-10.svg#linea-arrows-10',
    'fonts/linea-basic-10.eot',
    'fonts/linea-basic-10.eot?#iefix',
    'fonts/linea-basic-10.woff',
    'fonts/linea-basic-10.ttf',
    'fonts/linea-basic-10.svg#linea-basic-10',
    'fonts/linea-basic-elaboration-10.eot',
    'fonts/linea-basic-elaboration-10.eot?#iefix',
    'fonts/linea-basic-elaboration-10.woff',
    'fonts/linea-basic-elaboration-10.ttf',
    'fonts/linea-basic-elaboration-10.svg#linea-basic-elaboration-10',
    'fonts/linea-ecommerce-10.eot',
    'fonts/linea-ecommerce-10.eot?#iefix',
    'fonts/linea-ecommerce-10.woff',
    'fonts/linea-ecommerce-10.ttf',
    '../../images/preloaders/1.gif',
    '../../images/user-info.jpg',
    '../webfonts/fontawesome-webfont.eot?v=6.0.0',
    '../webfonts/fontawesome-webfont.eot?#iefix&v=6.0.0',
    '../webfonts/fontawesome-webfont.woff2?v=6.0.0',
    '../webfonts/fontawesome-webfont.woff?v=6.0.0',
    '../webfonts/fontawesome-webfont.ttf?v=6.0.0',
    '../webfonts/fontawesome-webfont.svg?v=6.0.0#fontawesomeregular',
    '../fonts/ionicons.eot?v=2.0.0',
    '../fonts/ionicons.eot?v=2.0.0#iefix',
    '../fonts/ionicons.ttf?v=2.0.0',
    '../fonts/ionicons.woff?v=2.0.0',
    '../fonts/ionicons.svg?v=2.0.0#Ionicons',
    'fonts/themify.eot?-fvbane',
    'fonts/themify.eot?#iefix-fvbane'
  ],
};

async function runBuild() {
  if (watch) {
    const ctx = await esbuild.context(options);
    await ctx.watch();
    console.log("👀 Watching for changes...");
  } else {
    await esbuild.build(options);
    console.log("✅ Build complete");
  }
}

runBuild().catch(() => process.exit(1));