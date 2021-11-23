# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        @createLights()

        @options.loaders.gltf.load("./scripts/tools/Scene/models/Burger/glTF/burger.glb", (gltf) =>

            gltf.scene.scale.set(0.3, 0.3, 0.3)
            gltf.scene.position.set(0, -1, 0)
            @options.scene.add gltf.scene

            # if @options.debug then @debug()
        )



    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        folder = @options.debug.addFolder({ title: "Burger", expanded: true })



    # ==================================================
    # > UTILS
    # ==================================================
    createLights: ->
        ambientLight = new THREE.AmbientLight(0xffffff, 0.8)
        @options.scene.add(ambientLight)

        directionalLight = new THREE.DirectionalLight(0xffffff, 0.6)
        directionalLight.castShadow = true
        directionalLight.shadow.mapSize.set(1024, 1024)
        directionalLight.shadow.camera.far = 15
        directionalLight.shadow.camera.left = -7
        directionalLight.shadow.camera.top = 7
        directionalLight.shadow.camera.right = 7
        directionalLight.shadow.camera.bottom = -7
        directionalLight.position.set(5, 5, 5)
        @options.scene.add(directionalLight)


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->