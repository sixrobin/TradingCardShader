Shader "Moon"
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
        _Cull ("Cull", Int) = 0
        
        [Header(BLEND)]
        [Space(5)]
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend ("Source Blend", float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend ("Destination Blend", float) = 1
        
        [Header(FLOATING)]
        [Space(5)]
        _FloatingAmplitude ("Floating Amplitude", Float) = 0
        _FloatingSpeed ("Floating Speed", Float) = 0
        
        [Header(GLOW)]
        [Space(5)]
        _GlowTexture ("Glow Texture", 2D) = "black" {}
        _GlowColor ("Glow Color", Color) = (1,1,1,1)
        _GlowIntensityMin ("Glow Intensity Min", Float) = 0
        _GlowIntensityMax ("Glow Intensity Max", Float) = 1
        _GlowSpeed ("Glow Speed", Float) = 1
        
        [PerRendererData] [HideInInspector] _MainTex ("Texture", 2D) = "white" {}
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
                float4 vertex : SV_POSITION;
                float2 uv     : TEXCOORD0;
                float4 color  : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _FloatingAmplitude;
            float _FloatingSpeed;
            
            sampler2D _GlowTexture;
            float4 _GlowColor;
            float _GlowIntensityMin;
            float _GlowIntensityMax;
            float _GlowSpeed;
            
            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertex.y += sin(_FloatingSpeed * _Time.y) * _FloatingAmplitude;
                
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 baseColor = tex2D(_MainTex, i.uv) * i.color;
                float4 glow = tex2D(_GlowTexture, i.uv) * _GlowColor;

                float glowIntensity = lerp(_GlowIntensityMin, _GlowIntensityMax, sin(_GlowSpeed * _Time.y) * 0.5 + 0.5);
                
                float4 color = baseColor * baseColor.a + glow * glowIntensity;
                
                return color;
            }
            
            ENDCG
        }
    }
}
