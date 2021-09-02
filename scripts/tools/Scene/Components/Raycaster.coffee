# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        @object1 = new THREE.Mesh(
            new THREE.SphereBufferGeometry(0.5, 16, 16)
            new THREE.MeshBasicMaterial({ color: "#ff0000" })
        )
        @object1.position.x = -2
        @options.scene.add(@object1)

        @object2 = new THREE.Mesh(
            new THREE.SphereBufferGeometry(0.5, 16, 16)
            new THREE.MeshBasicMaterial({ color: "#ff0000" })
        )
        @options.scene.add(@object2)

        @object3 = new THREE.Mesh(
            new THREE.SphereBufferGeometry(0.5, 16, 16)
            new THREE.MeshBasicMaterial({ color: "#ff0000" })
        )
        @object3.position.x = 2
        @options.scene.add(@object3)

        @raycaster = new THREE.Raycaster()
        @mouse = new THREE.Vector2()

        @debug()


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->
        # folder = @options.debug.addFolder({ title: "Galaxy", expanded: true })

        # folder.addInput(@config, "count", { min: 100, max: 1000000, step: 100 }).on("change", (e) => if e.last then @generate())
        # folder.addInput(@config, "size", { min: .001, max: .1, step: .001 }).on("change", (e) => if e.last then @generate())
        # folder.addInput(@config, "radius", { min: .01, max: 20, step: .01 }).on("change", (e) => if e.last then @generate())
        # folder.addInput(@config, "branches", { min: 2, max: 20, step: 1 }).on("change", (e) => if e.last then @generate())
        # folder.addInput(@config, "spin", { min: -5, max: 5, step: .001 }).on("change", (e) => if e.last then @generate())
        # folder.addInput(@config, "randomness", { min: 0, max: 2, step: .001 }).on("change", (e) => if e.last then @generate())
        # folder.addInput(@config, "randomnessPower", { min: 1, max: 20, step: .001 }).on("change", (e) => if e.last then @generate())
        # folder.addInput(@config, "insideColor").on("change", (e) => if e.last then @generate())
        # folder.addInput(@config, "outsideColor").on("change", (e) => if e.last then @generate())


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->

        @object1.position.y = Math.sin(elapsedTime * 1.43)
        @object2.position.y = Math.sin(elapsedTime * 1.30)
        @object3.position.y = Math.sin(elapsedTime * 1.32)

        # Mouse raycast
        @raycaster.setFromCamera(@mouse, @options.camera)

        objectsToTest = [ @object1, @object2, @object3 ]
        intersects = @raycaster.intersectObjects(objectsToTest)

        for obj in objectsToTest then obj.material.color.set("#ff0000")
        for obj in intersects then obj.object.material.color.set("#0000ff")

        # Basic ray to test the object
        # rayOrigin = new THREE.Vector3(-3, 0, 0)
        # rayDirection = new THREE.Vector3(1, 0, 0)
        # rayDirection.normalize()
        # @raycaster.set(rayOrigin, rayDirection)

        # objectsToTest = [ @object1, @object2, @object3 ]
        # intersects = @raycaster.intersectObjects(objectsToTest)

        # for obj in objectsToTest then obj.material.color.set("#ff0000")
        # for obj in intersects then obj.object.material.color.set("#0000ff")

    onMouseMove: (e) ->
        @mouse.x = e.clientX / window.innerWidth * 2 - 1
        @mouse.y = -(e.clientY / window.innerHeight) * 2 + 1
