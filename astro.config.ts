// import markdoc from "@astrojs/markdoc";
import mdx from "@astrojs/mdx";
import react from "@astrojs/react";
import tailwind from "@astrojs/tailwind";
import vercel from "@astrojs/vercel/serverless";
import keystatic from "@keystatic/astro";
import { defineConfig } from "astro/config";
import icon from "astro-icon";

const prodUrl = "https://digitarium.acdh-dev.oeaw.ac.at";
const devUrl = "https://curved-conjunction.vercel.app";
const prodBase = prodUrl.includes("https://digitarium.acdh-dev.oeaw.ac.at")
	? "/"
	: "/curved-conjunction";
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
		...(process.env.SKIP_KEYSTATIC ? [] : [keystatic()]),
		tailwind(),
		mdx(),
	],
	build: {
		format: "file",
	},
	output: process.env.SKIP_KEYSTATIC ? "static" : "hybrid",
	// output: "static",
	server: {
		port: 3000,
	},
	site: process.env.SKIP_KEYSTATIC ? prodUrl : devUrl,
	base: process.env.SKIP_KEYSTATIC ? prodBase : devBase,
	adapter: process.env.SKIP_KEYSTATIC ? undefined : vercel(),
});
