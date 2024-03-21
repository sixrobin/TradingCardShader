Shader "Card/Glass"
{
    Properties
    {
        [Header(STENCIL)]
        [Space(5)]
        _StencilRef ("Stencil Ref", Int) = 0
        _StencilComp ("Stencil Comp", Int) = 0
        _StencilPass ("Stencil Pass", Int) = 0
        
        [Header(CULL)]
        [Space(5)]
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Int) = 0
        
        [Header(BLEND)]
        [Space(5)]
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend ("Source Blend", float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend ("Destination Blend", float) = 1
        
        [Header(GLASS)]
        [Space(5)]
        _GlassNoise ("Glass Noise", 2D) = "black" {}
        _GlassScaleX ("Glass Scale X", Float) = 1
        _GlassExponent ("Glass Exponent", Float) = 3
        _GlassViewDirOffset ("Glass View Direction Offset", Float) = 0
        
        [PerRendererData] [HideInInspector] _MainTex ("Sprite Texture", 2D) = "white" {}
    }
    
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="TransparentCutout"
        }
        
        Stencil
        {
            Ref [_StencilRef]
            Comp [_StencilComp]
            Pass [_StencilPass]
        }
        
        Blend [_SrcBlend] [_DstBlend]
        Cull [_Cull]
        ZWrite Off

        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
                float4 color  : COLOR;
            };

            struct v2f
            {
                float4 vertex        : SV_POSITION;
                float2 uv            : TEXCOORD0;
                float4 color         : COLOR;
                float3 viewDirection : TEXCOORD1;
            };

            float3 hash23(float2 input)
            {
                float a = dot(input.xyx, float3(127.1, 311.7, 74.7));
                float b = dot(input.yxx, float3(269.5, 183.3, 246.1));
                float c = dot(input.xyy, float3(113.5, 271.9, 124.6));
                return frac(sin(float3(a, b, c)) * 43758.5453123);
            }

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _GlassNoise;
            float4 _GlassNoise_ST;
            float _GlassScaleX;
            float _GlassExponent;
            float _GlassViewDirOffset;

            float random(float x)  { return frac(sin(dot(x, 12.9898)) * 43758.5453); }
            float random(float2 v) { return frac(sin(dot(v, float2(12.9898, 78.233))) * 43758.5453); }
            float random(float3 v) { return frac(sin(dot(v, float3(12.9898, 78.233, 45.5432))) * 43758.5453); }
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                o.viewDirection = ObjSpaceViewDir(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 glassNoise = tex2D(_GlassNoise, i.uv * _GlassNoise_ST.xy).rg;
                float3 glassDirection = hash23(glassNoise);
                
                float glassShard = sin(dot(glassDirection, i.viewDirection));
                
                float glassShine = pow(max(0, sin(i.viewDirection.x * _GlassScaleX + _GlassViewDirOffset)), _GlassExponent);
                glassShine = saturate(glassShine);
                
                return (glassShine + glassShard) * i.color;
            }
            
            ENDCG
        }
    }
}
