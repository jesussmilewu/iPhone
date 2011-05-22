//
//  Shader.fsh
//  Layer
//
//  Created by Clemens Wagner on 22.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
