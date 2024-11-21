import { request } from "@acdh-oeaw/lib";

export const xmlDownload = async (url: string): Promise<string> => {
	return (await request(url, { responseType: "text" })) as string;
};
