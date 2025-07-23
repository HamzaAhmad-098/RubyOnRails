module.exports = {
  content: [
    "./app/views/**/*.{html,erb}",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {
      colors: {
        primary: '#4F46E5', // Indigo
        accent: '#A78BFA',  // Purple
        background: '#F8FAFC', // Slate-50
        text: '#1F2937', // Gray-800
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif']
      }
    },
  },
  plugins: [],
}
