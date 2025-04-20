const esbuild = require("esbuild");

const args = process.argv.slice(2);
const watch = args.includes("--watch");
const { sassPlugin } = require("esbuild-sass-plugin");
const { copy } = require("esbuild-plugin-copy");

const entryPoints = [
  "app/javascript/application.js",
  "app/assets/stylesheets/application.scss",
];

const options = {
  entryPoints: entryPoints,
  bundle: true,
  sourcemap: true,
  format: "esm",
  outdir: "app/assets/builds",
  publicPath: "/assets",
  plugins: [
    sassPlugin({
      loadPaths: ["node_modules"], 
    }),
  ],
  loader: {
    '.js': 'jsx',
    '.css': 'css',
    '.png': 'file',
    '.jpg': 'file',
    '.jpeg': 'file',
    '.svg': 'file',
    '.gif': 'file',
    '.webp': 'file',
    '.ico': 'file',
    '.woff': 'file',
    '.woff2': 'file',
    '.eot': 'file',
    '.ttf': 'file',
  },
  assetNames: 'webfonts/[name]-[hash]', 
  external: [],
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