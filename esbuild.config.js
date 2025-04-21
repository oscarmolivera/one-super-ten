const esbuild = require("esbuild");
const { sassPlugin } = require("esbuild-sass-plugin");

const args = process.argv.slice(2);
const watch = args.includes("--watch");

const jsOptions = {
  entryPoints: ["app/javascript/application.js"],
  bundle: true,
  sourcemap: true,
  format: "esm",
  outfile: "app/assets/builds/application.js",
  publicPath: "/assets",
  plugins: [
    sassPlugin({
      loadPaths: ["node_modules"],
      type: "style", // Inline CSS in JavaScript (optional, see below)
    }),
  ],
  loader: {
    ".js": "jsx",
    ".css": "css",
    ".scss": "css",
    ".png": "file",
    ".jpg": "file",
    ".jpeg": "file",
    ".svg": "file",
    ".gif": "file",
    ".webp": "file",
    ".ico": "file",
    ".woff": "file",
    ".woff2": "file",
    ".eot": "file",
    ".ttf": "file",
  },
  assetNames: "fonts/webfonts/[name]-[hash]", // Match Propshaft's digested path
  external: [],
};

const cssOptions = {
  entryPoints: ["app/assets/stylesheets/application.scss"],
  bundle: true,
  sourcemap: true,
  outdir: "app/assets/builds",
  publicPath: "/assets",
  plugins: [
    sassPlugin({
      loadPaths: ["node_modules"],
    }),
  ],
  loader: {
    ".css": "css",
    ".scss": "css",
    ".png": "file",
    ".jpg": "file",
    ".jpeg": "file",
    ".svg": "file",
    ".gif": "file",
    ".webp": "file",
    ".ico": "file",
    ".woff": "file",
    ".woff2": "file",
    ".eot": "file",
    ".ttf": "file",
  },
  assetNames: "fonts/webfonts/[name]-[hash]", // Match Propshaft's digested path
  external: [],
};

async function runBuild() {
  try {
    if (watch) {
      const jsCtx = await esbuild.context(jsOptions);
      const cssCtx = await esbuild.context(cssOptions);
      await Promise.all([jsCtx.watch(), cssCtx.watch()]);
      console.log("👀 Watching for changes...");
    } else {
      await Promise.all([
        esbuild.build(jsOptions),
        esbuild.build(cssOptions),
      ]);
      console.log("✅ Build complete");
    }
  } catch (error) {
    console.error("Build failed:", error);
    process.exit(1);
  }
}

runBuild();