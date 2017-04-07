//
//  Sprite.swift
//  Sprites
//
//  Created by Bernard Cosgriff on 4/5/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import GLKit

class Sprite {
    
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    
    var scaleX: Float = 1.0
    var scaleY: Float = 1.0
    
    // Rotation in radians or degrees
    var rotation: Float = 0.0
    
    let image: UIImage
    private var texture: GLKTextureInfo?
    
    private static let quad: [Float] = [
        0.4, -0.4,// Point(x,y)
        1.0, 1.0, //Texture Coordinate (x,y)
        1.0, 0.0, 0.0, 1.0, //Color (rgba)
        
        0.4, 0.4,
        1.0, 0.0,
        0.0, 1.0, 0.0, 1.0,
        
        -0.4, -0.4,
        0.0, 1.0,
        0.0, 0.0, 1.0, 1.0,
        
        -0.4, 0.4,
        0.0, 0.0,
        1.0, 1.0, 0.0, 1.0,
        ]
    
    private static var program: GLuint = 0
    
    init(image: UIImage) {
        self.image = image
        
        self.texture = try! GLKTextureLoader.texture(with: image.cgImage!, options: nil)
        
        Sprite.setup()
    }
    
    private static func setup() {
        //If program already created, return
        if program != 0 {
            return
        }
        
        let vertexShaderPath = Bundle.main.path(forResource: "sprite_vertex", ofType: "glsl", inDirectory: nil)!
        let vertexShaderSource = try! NSString(contentsOfFile: vertexShaderPath, encoding: String.Encoding.utf8.rawValue)
        var vertexShaderData = vertexShaderSource.cString(using: String.Encoding.utf8.rawValue)
        
        let vertexShader = glCreateShader(GLenum(GL_VERTEX_SHADER))
        glShaderSource(vertexShader, 1, &vertexShaderData, nil)
        glCompileShader(vertexShader)
        
        var vertexCompileStatus: GLint = GL_FALSE
        glGetShaderiv(vertexShader, GLenum(GL_COMPILE_STATUS), &vertexCompileStatus)
        
        if vertexCompileStatus == GL_FALSE {
            var logLength: GLint = 0
            
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            glGetShaderiv(vertexShader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            
            //TODO: Why is 3rd param nil?
            glGetShaderInfoLog(vertexShader, logLength, nil, logBuffer)
            
            let logString = String(cString: logBuffer)
            
            print(logString)
            fatalError("Compilation of Vertex Shader Failed")
        }
        
        let fragmentShaderPath = Bundle.main.path(forResource: "sprite_fragment", ofType: "glsl", inDirectory: nil)!
        let fragmentShaderSource = try! NSString(contentsOfFile: fragmentShaderPath, encoding: String.Encoding.utf8.rawValue)
        var fragmentShaderData = fragmentShaderSource.cString(using: String.Encoding.utf8.rawValue)
        
        let fragmentShader = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        glShaderSource(fragmentShader, 1, &fragmentShaderData, nil)
        glCompileShader(fragmentShader)
        
        var fragmentCompileStatus: GLint = GL_FALSE
        glGetShaderiv(fragmentShader, GLenum(GL_COMPILE_STATUS), &fragmentCompileStatus)
        
        if fragmentCompileStatus == GL_FALSE {
            var logLength: GLint = 0
            glGetShaderiv(fragmentShader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            glGetShaderInfoLog(fragmentShader, logLength, nil, logBuffer)
            
            let logString = String(cString: logBuffer)
            
            print(logString)
            fatalError("Compilation of Fragment Shader Failed")
        }
        program = glCreateProgram()
        glAttachShader(Sprite.program, vertexShader)
        glAttachShader(Sprite.program, fragmentShader)
        glBindAttribLocation(Sprite.program, 0, "position")
        glBindAttribLocation(Sprite.program, 1, "color")
        glBindAttribLocation(Sprite.program, 2, "textCoord")
        glLinkProgram(Sprite.program)
        
        var programLinkStatus: GLint = GL_FALSE
        glGetProgramiv(Sprite.program, GLenum(GL_LINK_STATUS), &programLinkStatus)
        
        if programLinkStatus == GL_FALSE {
            var logLength: GLint = 0
            glGetProgramiv(Sprite.program, GLenum(GL_LINK_STATUS), &logLength)
            
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            glGetProgramInfoLog(Sprite.program, logLength, nil, logBuffer)
            
            let logString = String(cString: logBuffer)
            
            print(logString)
            fatalError("Linking program failed")
        }
        
        glEnableVertexAttribArray(0)
        glEnableVertexAttribArray(1)
        glEnableVertexAttribArray(2)
        
        //Point (position)
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, quad)
        
        //Color
        glVertexAttribPointer(1, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, UnsafePointer(quad) + 4)
        
        //Texture
        glVertexAttribPointer(2, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, UnsafePointer(quad) + 2)
        print("Setting up Sprite")
    }
    
    func draw() {
        glUseProgram(Sprite.program)
        
        glBindTexture(GLenum(GL_TEXTURE_2D), texture!.name)
        glUniform2f(glGetUniformLocation(Sprite.program, "translate"), positionX, positionY)
//        glUniform2f(glGetUniformLocation(Sprite.program, "scale"), scaleX, scaleY)
//        glUniform1f(glGetUniformLocation(Sprite.program, "rotation"), rotation)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
    }
    
}
