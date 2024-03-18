Shader "Border"
{
    Properties
    {
        [Header(HOLOFOIL)]
        _HolofoilMask ("Holofoil Mask", 2D) = "white" {}
        _HolofoilColor ("Holofoil Color", Color) = (1,1,1,1)
        _HolofoilExponent ("Holofoil Exponent", Float) = 3
        _HolofoilViewDirOffset ("Holofoil View Direction Offset", Float) = 0

        [PerRendererData] [HideInInspector] _MainTex ("Sprite Texture", 2D) = "white" {}
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1,1,1,1)
        [HideInInspector] _Flip ("Flip", Vector) = (1,1,1,1)
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        CGPROGRAM
        
        #pragma surface surf Lambert vertex:vert nofog nolightmap nodynlightmap keepalpha noinstancing
        #pragma multi_compile _ ETC1_EXTERNAL_ALPHA
        #include "UnitySprites.cginc"

        struct Input
        {
            float2 uv_MainTex;
            float4 color;
            float3 viewDirection;
        };

        sampler2D _HolofoilMask;
        float4 _HolofoilColor;
        float _HolofoilExponent;
        float _HolofoilViewDirOffset;

        void vert(inout appdata_full v, out Input o)
        {
            v.vertex = UnityFlipSprite(v.vertex, _Flip);
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.color = v.color * _RendererColor;
            o.viewDirection = WorldSpaceViewDir(v.vertex);
        }

        void surf(Input i, inout SurfaceOutput o)
        {
            float4 color = SampleSpriteTexture(i.uv_MainTex) * i.color;

            float holofoilMask = tex2D(_HolofoilMask, i.uv_MainTex);
            holofoilMask *= pow(max(0, sin((i.viewDirection.x + _HolofoilViewDirOffset) + sin(i.viewDirection.y))), _HolofoilExponent);
            color.rgb += holofoilMask * _HolofoilColor * _HolofoilColor.a;
            
            o.Albedo = color.rgb * color.a;
            o.Alpha = color.a;
        }
        
        ENDCG
    }

    Fallback "Transparent/VertexLit"
}