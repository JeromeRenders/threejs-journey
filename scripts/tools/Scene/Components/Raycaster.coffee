# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        super()

        @title = "5. Raycaster"
        @desc  = "Testing a raycaster to merge mouse events with 3D objects"

        if @options.debug then @debug()


    # ==================================================
    # > INIT
    # ==================================================
    init: ->

        @updateCameraPosition({ x: 0, y: 4, z: 0 })

        size = 0.5
        segments = 32

        @mesh = new THREE.Group()

        @object1 = new THREE.Mesh(
            new THREE.SphereBufferGeometry(size, segments, segments)
            new THREE.MeshBasicMaterial({ color: "#ff0000" })
        )
        @object1.position.x = -2
        @mesh.add(@object1)

        @object2 = new THREE.Mesh(
            new THREE.SphereBufferGeometry(size, segments, segments)
            new THREE.MeshBasicMaterial({ color: "#ff0000" })
        )
        @mesh.add(@object2)

        @object3 = new THREE.Mesh(
            new THREE.SphereBufferGeometry(size, segments, segments)
            new THREE.MeshBasicMaterial({ color: "#ff0000" })
        )
        @object3.position.x = 2
        @mesh.add(@object3)

        @raycaster = new THREE.Raycaster()
        @mouse = new THREE.Vector2()

        @options.scene.add(@mesh)


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->
        @debugFolder = @options.debug.addFolder({ title: @title, expanded: false })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->
        if @raycaster
            @object1.position.z = Math.sin(elapsedTime * 1.43)
            @object2.position.z = Math.sin(elapsedTime * 1.30)
            @object3.position.z = Math.sin(elapsedTime * 1.32)

            # Mouse raycast
            @raycaster.setFromCamera(@mouse, @options.camera)

            objectsToTest = [ @object1, @object2, @object3 ]
            intersects = @raycaster.intersectObjects(objectsToTest)

            for obj in objectsToTest then obj.material.color.set("#ff0000")
            for obj in intersects then obj.object.material.color.set("#0000ff")

    onMouseMove: (e) ->
        if @mouse
            @mouse.x = e.clientX / window.innerWidth * 2 - 1
            @mouse.y = -(e.clientY / window.innerHeight) * 2 + 1
