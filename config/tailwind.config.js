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
        exit: 'fade-out-up 0.3s cubic-bezier(0.65, 0.05, 0.35, 1) forwards',
        'enter-fade': 'fade-in 0.6s cubic-bezier(0.65, 0.05, 0.35, 1) forwards',
        'exit-fade': 'fade-out 0.3s cubic-bezier(0.65, 0.05, 0.35, 1) forwards',
        'exit-spinner': 'fade-in 0.15s cubic-bezier(0.65, 0.05, 0.35, 1) 0.7s forwards',
      },
      colors: {
        grey: colors.zinc
      },
      data: {
        loading: 'loading',
        started: 'started',
        playing: 'playing',
        played: 'played',
        active: 'active',
        selected: 'selected'
      },
      fontFamily: {
        sans: ['Bespoke Sans', 'Seravek', 'Gill Sans Nova', 'Ubuntu', 'Calibri', 'DejaVu Sans', 'source-sans-pro', 'sans-serif'],
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
        },
        'fade-in': {
          '0%': {
            opacity: 0
          },
          '100%': {
            opacity: 1
          }
        },
        'fade-out': {
          '0%': {
            opacity: 1
          },
          '100%': {
            opacity: 0
          }
        }
      },
      typography: {
        DEFAULT: {
          css: {
            h1: {
              fontSize: '1rem',
              fontWeight: 600
            },
            h2: {
              fontSize: '1rem',
              fontWeight: 600,
            },
            h3: {
              fontSize: '1rem',
              fontWeight: 600
            },
            h4: {
              fontSize: '1rem',
              fontWeight: 600
            },
            h5: {
              fontSize: '1rem',
              fontWeight: 600
            },
            h6: {
              fontSize: '1rem',
              fontWeight: 600
            },
            ul: {
              paddingLeft: '1em'
            },
            ol: {
              paddingLeft: '1em'
            }
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
    plugin(function ({ addVariant }) {
      addVariant('turn-enter', ['.turn-advance.turn-enter &', '[data-animate-restore].turn-restore.turn-enter &'])
      addVariant('turn-exit', ['.turn-advance.turn-exit &', '[data-animate-restore].turn-restore.turn-exit &'])
      addVariant('turbo-preview', '[data-turbo-preview] &')
    }),
    plugin(function ({ addVariant }) {
      addVariant('range-track', [
        '&::-webkit-slider-runnable-track',
        '&::-moz-range-track'
      ])
      addVariant('range-thumb', [
        '&::-webkit-slider-thumb',
        '&::-moz-range-thumb'
      ])
      addVariant('range-progress', '&::-moz-range-progress')
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
