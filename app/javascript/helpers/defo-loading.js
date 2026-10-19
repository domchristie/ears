// FIXME: es-module-shim won't shim the dynamic import without this explicit import
import defo from "@icelab/defo"

// Eager load all views registered beneath the `under` path in the import map, and
// register them with defo in a single call.
export function eagerLoadViewsFrom(under) {
  const paths = Object.keys(parseImportmapJson()).filter(path => path.match(new RegExp(`^${under}/.*_view$`)))

  Promise.all(paths.map(path => importView(path, under))).then(entries => {
    defo({ views: Object.fromEntries(entries.filter(Boolean)) })
  })
}

function parseImportmapJson() {
  return JSON.parse(document.querySelector("script[type=importmap]").text).imports
}

function importView(path, under) {
  const name = camelize(identifierFromPath(path, under))

  return import(path)
    .then(module => [name, module.default])
    .catch(error => {
      if (error instanceof TypeError) {
        error.message = `Failed to register view: ${name} (${path})`
      }

      console.error(error)
      return null
    })
}

function identifierFromPath(path, under) {
  return path
    .replace(new RegExp(`^${under}/`), "")
    .replace("_view", "")
    .replace(/[/_]/g, "-")
}

// defo's views-object keys are camelCase (e.g. `pageTransitions`) — it dasherizes them
// internally to match attributes like `data-defo-page-transitions`.
function camelize(identifier) {
  return identifier.replace(/-+(\w)/g, (_, char) => char.toUpperCase())
}
