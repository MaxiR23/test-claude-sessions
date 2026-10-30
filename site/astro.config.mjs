import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
	integrations: [
		starlight({
			title: 'Bitácora agéntica',
			defaultLocale: 'root',
			locales: {
				root: { label: 'Español', lang: 'es' },
			},
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
				Hero: './src/components/Hero.astro',
				SiteTitle: './src/components/SiteTitle.astro',
				Footer: './src/components/Footer.astro',
			},
			sidebar: [
				{ label: 'Configuración', items: [{ autogenerate: { directory: 'configuracion' } }] },
				{ label: 'Workflow', items: [{ autogenerate: { directory: 'workflow' } }] },
			],
			expressiveCode: {
				styleOverrides: { codeForeground: 'var(--sl-color-text)' },
			},
		}),
	],
});
