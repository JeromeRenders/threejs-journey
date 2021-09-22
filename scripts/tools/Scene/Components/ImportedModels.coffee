# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        floor = new THREE.Mesh(
            new THREE.PlaneGeometry(10, 10),
            new THREE.MeshStandardMaterial({
                color: "#444444",
                metalness: 0,
                roughness: 0.5
            })
        )
        floor.receiveShadow = true
        floor.rotation.x = -Math.PI * 0.5
        @options.scene.add(floor)

        @createLights()

        @options.loaders.gltf.load("./scripts/tools/Scene/models/Duck/glTF-Draco/Duck.gltf", ((gltf) =>

                @options.scene.add gltf.scene

            ), (() ->
                # console.log "progress"
            ), ((e) ->
                console.log "error", e
            )
        )

        @debug()


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        folder = @options.debug.addFolder({ title: "Imported models", expanded: true })


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
