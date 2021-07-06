# =============================================================================
# > SCENE - COMPONENTS: DODECAHEDRON
# =============================================================================

import * as THREE    from "three"

import BaseComponent from "../BaseComponent.coffee"


# ==================================================
# > CLASS
# ==================================================
export default class extends BaseComponent

    constructor: (@options) ->
        @instancesID = "example"

        @beforeRender()

        @instancesItems = document.querySelectorAll("[data-trackable='#{@instancesID}']")
        @instances = @createInstances()

        @onMouseEvents()
        @afterRender()

        if @options.debug then @debug()


    # ==================================================
    # > RENDER
    # ==================================================
    beforeRender: ->
    afterRender: ->


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->


    # ==================================================
    # > INSTANCES
    # ==================================================
    createInstances: ->
        unless @instancesItems || @instancesModel
            console.error("No HTML elements to track and/or model to use")
            return

        instances = {}
        id = 0

        for item in @instancesItems
            id++

            item.dataset.glid = id
            item.classList.add("gl")

            instances[id] = new @instancesModel(item, @options, @config)

        return instances

    getInstanceByEl: (el) ->
        return @instances[el.dataset.glid]


    # ==================================================
    # > EVENTS
    # ==================================================
    onScroll: (e, isScrolling) ->
        for name, instance of @instances then instance._onScroll(e, isScrolling)

    onResize: (e) ->
        for name, instance of @instances then instance._onResize(e)

    onMouseMove: (e) ->
        for name, instance of @instances then instance._onMouseMove(e)

    onUpdate: ->
        for name, instance of @instances then instance._onUpdate()

    onMouseEvents: ->
        for el in @instancesItems

            el.addEventListener "mouseenter", (e) =>
                instance = @getInstanceByEl(e.currentTarget)
                instance._onMouseEnter()

            el.addEventListener "mouseleave", (e) =>
                instance = @getInstanceByEl(e.currentTarget)
                instance._onMouseLeave()




