type Rendered_element = {
	label_class: string;
	slider_class: string;
};
type Span_element = {
	css_class: string;
};
type Title = string;
type Hide = {
	hidden: boolean;
	class: string;
};
type Features = {
	all: Boolean;
	class: string;
};
type Variant = {
	opt: string;
	opt_slider?: string;
	title?: string;
	color?: string;
	html_class?: string;
	css_class?: string;
	hide?: Hide;
	chg_citation?: string;
	features: Features;
	default?: Boolean;
	custom_function?: Object;
};
type AnnotationType = {
	title?: Title;
	variants: Array<Variant>;
	span_element?: Span_element;
	active_class?: string;
	rendered_element?: Rendered_element;
};
type FullScreenVariant = {
	opt: string;
	title?: string;
	hide?: string;
	to_hide?: string;
	chg_citation?: string;
	urlparam?: string;
};
type FullScreenType = {
	name: string;
	variants: Array<FullScreenVariant>;
	active_class?: string;
	render_class?: string;
	render_svg?: string;
};
type Sizes = {
	default: string;
	[key: string]: string;
};
type Fonts = {
	default: string;
	[key: string]: string;
};
type FontVariant = {
	opt: string;
	title?: string;
	urlparam?: string;
	sizes?: Sizes;
	fonts?: Fonts;
	paragraph?: string;
	p_class?: string;
	css_class?: string;
	chg_citation?: string;
};
type FontSizeType = {
	name: string;
	variants: Array<FontVariant>;
	active_class?: string;
	html_class?: string;
};
type FontFamilyType = {
	name: string;
	variants: Array<FontVariant>;
	active_class?: string;
	html_class?: string;
};
type ImageSwitchVariant = {
	opt: string;
	title?: string;
	urlparam?: string;
	chg_citation?: string;
	fade?: string;
	column_small?: {
		class: string;
		percent: string;
	};
	column_full?: {
		class: string;
		percent: string;
	};
	hide?: {
		class_to_hide: string;
		class_to_show: string;
		resize?: string;
	};
	image_size?: string;
};
type ImageSwitchType = {
	name: string;
	variants: Array<ImageSwitchVariant>;
	active_class?: string;
	rendered_element?: {
		a_class: string;
		svg: string;
	};
};
type PageUrlType = {
	name: string;
	opt: string;
	title: string;
	urlparam: string;
	chg_citation: string;
	pag_link: string;
	pag_tab: string;
	url: string;
	img_size: string;
	url_param: string;
	osd_target: string;
	img_source: string;
	img_types?: Array<string>;
	active_class: string;
	inactive_class: string;
	bootstrap_class: string;
};
type MultiLanguageVariant = {
	opt: string;
	title?: string;
	class?: string;
	map?: {
		[key: string]: string;
	};
};
type MultiLanguageType = {
	title: string;
	variants: Array<MultiLanguageVariant>;
	active_class?: string;
};
type ImageLoaderType = {
	name: string;
	opt: string;
	title?: string;
	urlparam: string;
	chg_citation?: string;
	pag_link: string;
	pag_tab: string;
	img_size?: string;
	url: string;
	url_param: string;
	osd_target: string;
	img_source: string;
	img_types?: Array<string>;
	active_class?: string;
	inactive_class?: string;
	bootstrap_class?: string;
};

declare class UrlSearchParamUpdate {
	fullScreen(): void;
	fontSize(): void;
	fontFamily(): void;
	viewerSwitch(): void;
	textFeatures(): void;
	pageUrl(): void;
	multiLanguage(): void;
}

declare class LoadEditor {
	aot: AnnotationType | false;
	fs: FullScreenType | false;
	fos: FontSizeType | false;
	ff: FontFamilyType | false;
	is: ImageSwitchType | false;
	il: ImageLoaderType | false;
	ep: PageUrlType | false;
	wr: boolean | false;
	up: boolean | false;
	upc: UrlSearchParamUpdate;
	lang: MultiLanguageType | false;
	constructor(options: {
		aot?: AnnotationType;
		fs?: FullScreenType;
		fos?: FontSizeType;
		ff?: FontFamilyType;
		is?: ImageSwitchType;
		il?: ImageLoaderType;
		ep?: PageUrlType;
		wr?: boolean;
		up?: boolean;
		lang?: MultiLanguageType;
	});
}

export { LoadEditor };
