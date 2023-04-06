'use strict'

const $sets = Symbol('sets')

class NavigationCatalog {
  constructor () {
    this[$sets] = {}
  }

  addTree (component, version, tree) {
    const key = generateKey(component, version)
    const navigation = this[$sets][key] || (this[$sets][key] = [])
    // NOTE retain order on insert
    const insertIdx = navigation.findIndex((candidate) => candidate.order >= tree.order)
    ~insertIdx ? navigation.splice(insertIdx, 0, tree) : navigation.push(tree)
    return navigation
  }

  addNavigation (component, version, trees) {
    return (this[$sets][generateKey(component, version)] = trees.sort((a, b) => a.order - b.order))
  }

  getNavigation (component, version) {
    return this[$sets][generateKey(component, version)]
  }
}

function generateKey (component, version) {
  return version + '@' + component
}

module.exports = NavigationCatalog
