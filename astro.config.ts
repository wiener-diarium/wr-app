// import markdoc from "@astrojs/markdoc";
import mdx from "@astrojs/mdx";
import react from "@astrojs/react";
import tailwind from "@astrojs/tailwind";
import vercel from "@astrojs/vercel/serverless";
import keystatic from "@keystatic/astro";
import { defineConfig } from "astro/config";
import icon from "astro-icon";

// const prodUrl = "https://digitarium.acdh-dev.oeaw.ac.at";
const devUrl = "https://wr-app.vercel.app";
// const prodBase = prodUrl.includes("https://digitarium.acdh-dev.oeaw.ac.at") ? "/" : "/wr-app";
const devBase = "/";

// https://astro.build/config
export default defineConfig({
	integrations: [
		icon({
			include: {
				lucide: ["*"],
			},
			svgoOptions: {
				multipass: true,
				plugins: [
					{
						name: "preset-default",
						params: {
							overrides: {
								removeViewBox: false,
							},
						},
					},
				],
			},
		}),
		react(),
		keystatic(),
		tailwind(),
		mdx(),
	],
	build: {
		format: "file",
	},
	output: "hybrid",
	// output: "static",
	server: {
		port: 3000,
	},
	site: devUrl,
	base: devBase,
	adapter: vercel(),
});
