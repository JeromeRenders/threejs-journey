# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        @title = "2. Shadows"

        @config = {
            ambientLight: {
                "intensity": 0.5
            },
            directionalLight: {
                intensity: 0.5,
                pos: {
                    x: 2,
                    y: 2,
                    z: -1
                }
            },
            material: {
                metalness: 0
                roughness: 0.7
            }
        }

        if @options.debug then @debug()


    # ==================================================
    # > INIT
    # ==================================================
    init: ->
        @mesh = new THREE.Group()

        @updateCameraPosition({ x: 1.5, y: 2, z: 6 })

        bakedShadow = @options.loaders.texture.load("./scripts/tools/Scene/textures/shadows/simpleShadow.jpg")

        # Main light
        @main = new THREE.AmbientLight(0xffffff, @config.ambientLight.intensity)
        @mesh.add(@main)

        # Directionnal light
        @point = new THREE.DirectionalLight(0xffffff, @config.directionalLight.intensity)
        @point.position.set(@config.directionalLight.pos.x, @config.directionalLight.pos.y, @config.directionalLight.pos.z)
        @mesh.add(@point)


        # Material of objects
        @material = new THREE.MeshStandardMaterial()
        @material.metalness = @config.material.metalness
        @material.roughness = @config.material.roughness

        # Sphere
        objectGeometry = new THREE.SphereBufferGeometry(1, 32, 32)
        @object = new THREE.Mesh(objectGeometry, @material)
        @mesh.add @object

        # Plane
        planeGeometry = new THREE.PlaneBufferGeometry(8, 8)
        @plane = new THREE.Mesh(planeGeometry, @material)
        @plane.position.y = -1
        @plane.rotation.x = -Math.PI * .5
        @plane.material.side = THREE.DoubleSide
        @mesh.add @plane

        # Sphere shadow
        @objectShadow = new THREE.Mesh(new THREE.PlaneBufferGeometry(3, 3), new THREE.MeshBasicMaterial({
            color: 0x000000
            transparent: true
            alphaMap: bakedShadow
        }))
        @objectShadow.position.y = @plane.position.y + .01
        @objectShadow.rotation.x = -Math.PI * .5
        @mesh.add @objectShadow

        @options.scene.add(@mesh)


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->
        @debugFolder = @options.debug.addFolder({ title: @title, expanded: false })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()

        ambientLight = @debugFolder.addFolder({ title: "Ambient light", expanded: false })
        ambientLight.addInput(@config.ambientLight, "intensity", { min: 0, max: 1, step: .01 }).on("change", (val) =>
            if @main then @main.intensity = @config.ambientLight.intensity
        )

        light = @debugFolder.addFolder({ title: "Light", expanded: false })
        light.addInput(@config.directionalLight, "intensity", { min: 0, max: 1, step: .01 }).on("change", (val) =>
            if @point then @point.intensity = @config.directionalLight.intensity
        )
        light.addInput(@config.directionalLight.pos, "x", { min: -5, max: 15, step: .01 }).on("change", (val) =>
            if @point then @point.position.x = @config.directionalLight.pos.x
        )
        light.addInput(@config.directionalLight.pos, "y", { min: -5, max: 15, step: .01 }).on("change", (val) =>
            if @point then @point.position.y = @config.directionalLight.pos.y
        )
        light.addInput(@config.directionalLight.pos, "z", { min: -5, max: 15, step: .01 }).on("change", (val) =>
            if @point then @point.position.z = @config.directionalLight.pos.z
        )

        material = @debugFolder.addFolder({ title: "Material", expanded: false })
        material.addInput(@config.material, "metalness", { min: 0, max: 1, step: .01 }).on("change", (val) =>
            if @material then @material.metalness = @config.material.metalness
        )
        material.addInput(@config.material, "roughness", { min: 0, max: 1, step: .01 }).on("change", (val) =>
            if @material then @material.roughness = @config.material.roughness
        )


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->
        if @object
            @object.position.x = Math.cos elapsedTime * 2
            @object.position.z = Math.sin elapsedTime * 2
            @object.position.y = Math.abs Math.sin elapsedTime * 3.5

            @objectShadow.position.x = @object.position.x
            @objectShadow.position.z = @object.position.z
            @objectShadow.material.opacity = (1 - @object.position.y) * .8
