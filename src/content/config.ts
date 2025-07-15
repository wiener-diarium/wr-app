// import { file } from "astro/loaders";
import { defineCollection, z } from "astro:content";

// Export a single `collections` object to register your collection(s)
export const collections = {
	// edition: defineCollection({
	// 	loader: file("edition/about.json"),
	// 	schema: z.object({
	// 		id: z.string(),
	// 		title: z.string(),
	// 		corpus: z.string(),
	// 	}),
	// }),
	publications: defineCollection({
		type: "data",
		schema: z.object({
			title: z.string(),
			publicationUnstructured: z.string().optional(),
			authors: z.array(
				z
					.object({
						firstName: z.string(),
						lastName: z.string(),
						middleName: z.string().optional(),
					})
					.optional(),
			),
			year: z.string().optional(),
			publishedIn: z.string().optional(),
			publishers: z.array(z.string()).optional(),
			pubPlace: z.string().optional(),
			volume: z.string().optional(),
			pages: z.string().optional(),
			url: z.string().optional(),
			urldate: z
				.string()
				.optional()
				.transform((str: string) => (str ? new Date(str) : "")),
		}),
	}),
	presentations: defineCollection({
		type: "data",
		schema: z.object({
			presentationUnstructured: z.string().optional(),
			title: z.string(),
			type: z.string(),
			authors: z.array(
				z.object({
					firstName: z.string(),
					lastName: z.string(),
					middleName: z.string().optional(),
				}),
			),
			date: z
				.string()
				.optional()
				.transform((str: string) => (str ? new Date(str) : "")),
			place: z.string().optional(),
			url: z.string().optional(),
		}),
	}),
	events: defineCollection({
		type: "content",
		schema: z.object({
			type: z.string(),
			authors: z.array(
				z.object({
					firstName: z.string(),
					lastName: z.string(),
					middleName: z.string().optional(),
				}),
			),
			title: z.string(),
			date: z.date().optional(),
			place: z.string().optional(),
			url: z.string().optional(),
			image: z.string().optional(),
		}),
	}),
	news: defineCollection({
		type: "content",
		schema: z.object({
			authors: z.array(
				z.object({
					firstName: z.string(),
					lastName: z.string(),
					middleName: z.string().optional(),
				}),
			),
			title: z.string(),
			date: z.date().optional(),
			url: z.string().optional(),
			image: z.string().optional(),
		}),
	}),
	media: defineCollection({
		type: "data",
		schema: z.object({
			authors: z.array(
				z.object({
					firstName: z.string(),
					lastName: z.string(),
					middleName: z.string().optional(),
				}),
			),
			title: z.string(),
			date: z.string().optional(),
			url: z.string().optional(),
			image: z.string().optional(),
			subTitle: z.string().optional(),
		}),
	}),
};
