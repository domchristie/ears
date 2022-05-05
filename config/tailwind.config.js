const defaultTheme = require('tailwindcss/defaultTheme')
const plugin = require('tailwindcss/plugin')

module.exports = {
  darkMode: 'class',
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/assets/images/**/*.svg'
  ],
  theme: {
    extend: {
      animation: {
        enter: 'fade-in-up 0.6s cubic-bezier(0.65, 0.05, 0.35, 1) forwards',
        exit: 'fade-out-up 0.3s cubic-bezier(0.65, 0.05, 0.35, 1) forwards',
      },
      fontFamily: {
        sans: ['Bespoke Sans', ...defaultTheme.fontFamily.sans],
        mono: ['Roboto Mono', ...defaultTheme.fontFamily.mono],
        native: defaultTheme.fontFamily.sans,
      },
      keyframes: {
        'fade-in-up': {
          '0%': {
            opacity: 0,
            '--tw-translate-y': '4rem',
            transform: 'translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))'
          },
          '100%': {
            opacity: 1,
            '--tw-translate-y': 0,
            transform: 'translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))'
          }
        },
        'fade-out-up': {
          '0%': {
            opacity: 1,
            '--tw-translate-y': 0,
            transform: 'translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))'
          },
          '100%': {
            opacity: 0,
            '--tw-translate-y': '-4rem',
            transform: 'translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))'
          }
        }
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp')
  ]
}
