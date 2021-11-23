# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"

# import vertex   from "../shaders/raging-sea/vertex.vert"
# import fragment from "../shaders/raging-sea/fragment.frag"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        @title = "10. Modified Materials"

        @config = {
            time: { value: 0 }
            deformation: { value: 0.26 }
            speed: { value: 1 }
        }

        if @options.debug then @debug()


    # ==================================================
    # > INIT
    # ==================================================
    init: ->

        @updateCameraPosition({ x: 10, y: 5, z: 10 })

        @mesh = new THREE.Group()

        @createLights()

        mapTexture = @options.loaders.texture.load("./scripts/tools/Scene/models/LeePerrySmith/color.jpg")
        mapTexture.encoding = THREE.sRGBEncoding

        normalTexture = @options.loaders.texture.load("./scripts/tools/Scene/models/LeePerrySmith/normal.jpg")

        @material = new THREE.MeshStandardMaterial({
            map: mapTexture
            normalMap: normalTexture
        })
        @material.onBeforeCompile = ((shader) =>
            shader.uniforms.uTime = @config.time
            shader.uniforms.uDeformation = @config.deformation
            shader.uniforms.uSpeed = @config.speed

            shader.vertexShader = shader.vertexShader.replace(
                "#include <common>",
                """
                    #include <common>

                    uniform float uTime;
                    uniform float uDeformation;
                    uniform float uSpeed;

                    mat2 get2dRotateMatrix (float _angle) {
                        return mat2(
                            cos(_angle),
                            - sin(_angle),
                            sin(_angle),
                            cos(_angle)
                        );
                    }
                """
            )

            shader.vertexShader = shader.vertexShader.replace(
                "#include <beginnormal_vertex>",
                """
                    #include <beginnormal_vertex>

                    float angle = (sin(position.y + uTime * uSpeed)) * uDeformation;
                    mat2 rotateMatrix = get2dRotateMatrix(angle);

                    objectNormal.xz = objectNormal.xz * rotateMatrix;
                """
            )

            shader.vertexShader = shader.vertexShader.replace(
                "#include <begin_vertex>",
                """
                    #include <begin_vertex>

                    transformed.xz = transformed.xz * rotateMatrix;
                """
            )
        )

        @depthMaterial = new THREE.MeshDepthMaterial({
            depthPacking: THREE.RGBADepthPacking
        })
        @depthMaterial.onBeforeCompile = ((shader) =>
            shader.uniforms.uTime = @config.uTime

            shader.vertexShader = shader.vertexShader.replace(
                "#include <common>",
                """
                    #include <common>

                    uniform float uTime;
                    uniform float uDeformation;
                    uniform float uSpeed;

                    mat2 get2dRotateMatrix (float _angle) {
                        return mat2(
                            cos(_angle),
                            - sin(_angle),
                            sin(_angle),
                            cos(_angle)
                        );
                    }
                """
            )

            shader.vertexShader = shader.vertexShader.replace(
                "#include <begin_vertex>",
                """
                    #include <begin_vertex>

                    float angle = (sin(position.y + uTime * uSpeed)) * uDeformation;
                    mat2 rotateMatrix = get2dRotateMatrix(angle);

                    transformed.xz = transformed.xz * rotateMatrix;
                """
            )
        )

        @options.loaders.gltf.load("./scripts/tools/Scene/models/LeePerrySmith/LeePerrySmith.glb", ((gltf) =>

                object = gltf.scene.children[0]
                object.position.set(0, 1, 0)
                object.rotation.y = Math.PI * 0.15
                object.material = @material
                object.customDepthMaterial = @depthMaterial

                @mesh.add(object)

                @updateAllMaterials()
            )
        )

        @options.scene.add(@mesh)


    # ==================================================
    # > UTILS
    # ==================================================
    createLights: (showHelpers = false) ->

        light = new THREE.DirectionalLight("#ffffff", 3)
        light.castShadow = true
        light.shadow.mapSize.set(1024, 1024)
        light.shadow.camera.far = 15
        light.shadow.normalBias = 0.05
        light.position.set(0, 10, 10)
        @mesh.add(light)

    updateAllMaterials: ->
        @mesh.traverse (child) =>
            if child instanceof THREE.Mesh && child.material instanceof THREE.MeshStandardMaterial
                child.material.envMapIntensity = @config.envMapIntensity
                child.material.needsUpdate = true
                child.castShadow = true
                child.receiveShadow = true


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        @debugFolder = @options.debug.addFolder({ title: @title, expanded: false })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()

        @debugFolder.addInput(@config.deformation, "value", { min: -1, max: 1, step: 0.01, label: "deformation" })
        @debugFolder.addInput(@config.speed, "value", { min: 0.1, max: 5, step: 0.1, label: "speed" })


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->
        unless @material then return

        @config.time.value = elapsedTime
