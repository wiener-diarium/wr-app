// import markdoc from "@astrojs/markdoc";
import mdx from "@astrojs/mdx";
import react from "@astrojs/react";
import tailwind from "@astrojs/tailwind";
// import vercel from "@astrojs/vercel/serverless";
// import keystatic from "@keystatic/astro";
import { defineConfig } from "astro/config";
import icon from "astro-icon";

// https://astro.build/config
export default defineConfig({
	vite: {
		server: {
			watch: {
				ignored: [
					"**/node_modules/**",
					"**/.git/**",
					"**/data/**",
					"**/edition/**",
					"**/saxon/**",
					"**/dist/**",
					"**/.vscode/**",
					"**/.github/**",
					"**/scripts/**",
				],
			},
		},
	},
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
		tailwind(),
		mdx(),
	],
	build: {
		format: "file",
	},
	output: "static",
	// output: "static",
	server: {
		port: 3000,
	},
	site: "https://wiener-diarium.github.io/wr-app",
	// base: "/wr-app/",
});
