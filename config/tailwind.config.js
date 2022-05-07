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
            transform: 'translate3d(0, 4rem, 0)'
          },
          '100%': {
            opacity: 1,
            transform: 'translateZ(0)'
          }
        },
        'fade-out-up': {
          '0%': {
            opacity: 1,
            transform: 'transform: translateZ(0)'
          },
          '100%': {
            opacity: 0,
            transform: 'translate3d(0, -4rem, 0)'
          }
        }
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp'),
    plugin(function ({ addVariant }) {
      addVariant('turn-enter', '.turn-enter &')
      addVariant('turn-exit', '.turn-exit &')
    })
  ]
}
