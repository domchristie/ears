const defaultTheme = require('tailwindcss/defaultTheme')
const plugin = require('tailwindcss/plugin')
const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/assets/images/**/*.svg'
  ],
  theme: {
    extend: {
      utopia: {
        spacing: {
          '4xs': 0.125,
          '4xl': 8,
          '5xl': 11,
          '6xl': 16,
          '7xl': 22,
          '8xl': 32,
        }
      },
      animation: {
        press: 'press 0.3s cubic-bezier(0.65, 0.05, 0.35, 1) forwards',
        enter: 'fade-in-up 0.6s cubic-bezier(0.65, 0.05, 0.35, 1) forwards',
        exit: 'fade-out-up 0.3s cubic-bezier(0.65, 0.05, 0.35, 1) 0.1s forwards',
      },
      colors: {
        grey: colors.zinc
      },
      fontFamily: {
        sans: ['Bespoke Sans', ...defaultTheme.fontFamily.sans],
        mono: ['Roboto Mono', ...defaultTheme.fontFamily.mono],
        native: defaultTheme.fontFamily.sans,
      },
      keyframes: {
        'press': {
          '0%': {
            transform: 'scale(1)'
          },
          '50%': {
            transform: 'scale(0.95)'
          },
          '100%': {
            transform: 'scale(1)'
          }
        },
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
    require('tailwind-utopia')(),
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp'),
    plugin(function ({ addVariant }) {
      addVariant('turn-enter', '.turn-enter &')
      addVariant('turn-exit', '.turn-exit &')
    }),
    plugin(function ({ addVariant }) {
      addVariant('loading', '&[data-loading]')
      addVariant('group-loading', '.group[data-loading] &')
      addVariant('started', '&[data-started]')
      addVariant('group-started', '.group[data-started] &')
      addVariant('playing', '&[data-playing]')
      addVariant('group-playing', '.group[data-playing] &')
      addVariant('played', '&[data-played]')
      addVariant('group-played', '.group[data-played] &')
      addVariant('active', '&[data-active]')
      addVariant('group-active', '.group[data-active] &')
    }),
    plugin(function ({ addUtilities }) {
      addUtilities({
        '.min-h-dscreen': generate('minHeight'),
        '.h-dscreen': generate('height')
      })

      function generate (property) {
        return {
          [property]: [
            'calc(100vh - env(safe-area-inset-bottom, 0) - env(safe-area-inset-top, 0))',
            '100dvh'
          ],
          '@supports (-webkit-touch-callout: none)': {
            [property]: ['-webkit-fill-available', '100dvh']
          }
        }
      }
    })
  ]
}
