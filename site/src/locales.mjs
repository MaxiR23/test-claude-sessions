// The site's locales, declared once. Starlight's config, the language
// detection in Head.astro and the components read them from here.
export const defaultLocale = 'root';
export const locales = {
	root: { label: 'Español', lang: 'es' },
	en: { label: 'English', lang: 'en' },
};
// Path prefix of a locale: '' for the root locale, '/<key>' for the others.
// Accepts a locales key or Starlight's route locale (undefined for root).
export const localeBase = (locale) => (!locale || locale === 'root' ? '' : `/${locale}`);
