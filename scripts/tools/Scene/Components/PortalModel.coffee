# =============================================================================
# > SCENE - COMPONENTS: BASE COMPONENT
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"

import firefliesVertex   from "../shaders/portal-fireflies/vertex.vert"
import firefliesFragment from "../shaders/portal-fireflies/fragment.frag"
import portalVertex      from "../shaders/portal-portal/vertex.vert"
import portalFragment    from "../shaders/portal-portal/fragment.frag"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        @title = "11. Portal Model"
        @desc  = "Creating a full 3D model in Blender, importing it in THREE.js and adding custom effects with GLSL"

        @config = {
            bgColor: "#161616"
            firefliesSize: 12.0
            portalColorA: "#161616"
            portalColorB: "#c8e4ef"
        }

        @init()
        @load()

        if @options.debug then @debug()


    # ==================================================
    # > INIT
    # ==================================================
    init: ->

        @updateCameraPosition({ x: 2.5, y: 2, z: 3 })
        @options.renderer.setClearColor(@config.bgColor)

        @mesh = new THREE.Group()

        bakedTexture          = @options.loaders.texture.load("./scripts/tools/Scene/models/Portal/baked.jpg")
        bakedTexture.flipY    = false
        bakedTexture.encoding = THREE.sRGBEncoding
        @options.renderer.outputEncoding = THREE.sRGBEncoding

        backedMaterial       = new THREE.MeshBasicMaterial({ map: bakedTexture })
        poleLightMaterial    = new THREE.MeshBasicMaterial({ color: 0xffffe5 })
        @portalLightMaterial = new THREE.ShaderMaterial(
            uniforms: {
                uTime: { value: 0 }
                uColorA: { value: new THREE.Color(@config.portalColorA) }
                uColorB: { value: new THREE.Color(@config.portalColorB) }
            }
            vertexShader: portalVertex
            fragmentShader: portalFragment
            wireframe: false
        )

        @options.loaders.gltf.load("./scripts/tools/Scene/models/Portal/baked.glb", (gltf) =>
            gltf.scene.traverse (child) =>
                if child.name == "Cube014" || child.name == "Cube018" || child.name == "Cube054"
                    child.material = poleLightMaterial
                else if child.name == "Circle"
                    child.material = @portalLightMaterial
                else
                    child.material = backedMaterial
            @mesh.add gltf.scene
        )

        firefliesGeometry  = new THREE.BufferGeometry()
        firefliesAmount    = 40
        firefliesPositions = new Float32Array(firefliesAmount * 3)
        firefliesScales    = new Float32Array(firefliesAmount)

        for i in [0..firefliesAmount]
            firefliesPositions[i * 3 + 0] = (Math.random() - 0.5) * 4
            firefliesPositions[i * 3 + 1] = Math.random() * 1.5
            firefliesPositions[i * 3 + 2] = (Math.random() - 0.5) * 4

            firefliesScales[i] = Math.random()

        firefliesGeometry.setAttribute("position", new THREE.BufferAttribute(firefliesPositions, 3))
        firefliesGeometry.setAttribute("aScale", new THREE.BufferAttribute(firefliesScales, 1))

        @firefliesMaterial = new THREE.ShaderMaterial(
            uniforms: {
                uTime: { value: 0 }
                uPixelRatio: { value: Math.min(window.devicePixelRatio, 2) }
                uSize: { value: @config.firefliesSize }
            }
            vertexShader: firefliesVertex
            fragmentShader: firefliesFragment
            wireframe: false
            transparent: true
            depthWrite: false
            side: THREE.DoubleSide
            blending: THREE.AdditiveBlending
        )
        fireflies = new THREE.Points(firefliesGeometry, @firefliesMaterial)

        @mesh.add(fireflies)

        @options.scene.add(@mesh)


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->
        @debugFolder = @options.debug.addFolder({ title: @title, expanded: false })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()

        @debugFolder.addInput(@config, "bgColor", { label: "bgColor" }).on("change", (val) =>
            @options.renderer.setClearColor(@config.bgColor)
        )
        @debugFolder.addInput(@config, "firefliesSize", { min: 0, max: 100, step: 1, label: "firefliesSize" }).on("change", (val) =>
            @firefliesMaterial.uniforms.uSize.value = @config.firefliesSize
        )

        @debugFolder.addInput(@config, "portalColorA", { label: "portalColorA" }).on("change", (val) =>
            @portalLightMaterial.uniforms.uColorA.value = new THREE.Color(@config.portalColorA)
        )
        @debugFolder.addInput(@config, "portalColorB", { label: "portalColorB" }).on("change", (val) =>
            @portalLightMaterial.uniforms.uColorB.value = new THREE.Color(@config.portalColorB)
        )

    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->
        if @portalLightMaterial then @portalLightMaterial.uniforms.uTime.value = elapsedTime
        if @firefliesMaterial then @firefliesMaterial.uniforms.uTime.value = elapsedTime
