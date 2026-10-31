import { readFileSync } from 'node:fs';
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import { defaultLocale, locales } from './src/locales.mjs';

// Interface strings, one JSON file per lang. Components read the same files
// through Astro.locals.t(); the config cannot, so it reads them directly.
const langs = Object.values(locales).map(({ lang }) => lang);
const defaultLang = locales[defaultLocale].lang;
const messages = Object.fromEntries(
	langs.map((lang) => [lang, JSON.parse(readFileSync(new URL(`./src/content/i18n/${lang}.json`, import.meta.url), 'utf8'))]),
);
const translated = (key) => Object.fromEntries(langs.map((lang) => [lang, messages[lang][key]]));
const group = (key, directory) => ({
	label: messages[defaultLang][key],
	translations: translated(key),
	items: [{ autogenerate: { directory } }],
});

export default defineConfig({
	integrations: [
		starlight({
			title: translated('site.title'),
			defaultLocale,
			locales,
			customCss: [
				'@fontsource/space-grotesk/400.css',
				'@fontsource/space-grotesk/600.css',
				'@fontsource/inter/400.css',
				'@fontsource/inter/600.css',
				'@fontsource/jetbrains-mono/400.css',
				'@fontsource/jetbrains-mono/600.css',
				'./src/styles/tokens.css',
			],
			components: {
				Head: './src/components/Head.astro',
				LanguageSelect: './src/components/LanguageSelect.astro',
				Hero: './src/components/Hero.astro',
				SiteTitle: './src/components/SiteTitle.astro',
				Footer: './src/components/Footer.astro',
			},
			sidebar: [
				group('sidebar.setup', 'configuracion'),
				group('sidebar.workflow', 'workflow'),
			],
			expressiveCode: {
				styleOverrides: { codeForeground: 'var(--sl-color-text)' },
			},
		}),
	],
});
