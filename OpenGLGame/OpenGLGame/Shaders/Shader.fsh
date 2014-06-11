//
//  Shader.fsh
//  OpenGLGame
//
//  Created by Chris Lesch on 6/11/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
