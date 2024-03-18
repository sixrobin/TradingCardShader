Shader "Card Element"
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
        
        [Header(WIND)]
        [Space(5)]
        _WindNoise ("Wind Noise", 2D) = "black" {}
        [MaterialToggle] _UseWindMaskTexture ("Use Wind Mask Texture", Float) = 0
        _WindMaskTexture ("Wind Mask Texture", 2D) = "black" {}
        _WindIntensity ("Wind Intensity", Float) = 0
        _WindMaskMin ("Wind Mask Min", Range(0, 1)) = 0
        _WindMaskMax ("Wind Mask Max", Range(0, 1)) = 1
        
        [PerRendererData] _MainTex ("Texture", 2D) = "white" {}
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
                float3 color  : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv     : TEXCOORD0;
                float3 color  : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _WindNoise;
            float4 _WindNoise_ST;
            float _UseWindMaskTexture;
            sampler2D _WindMaskTexture;
            float _WindIntensity;
            float _WindMaskMin;
            float _WindMaskMax;
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float wind = tex2D(_WindNoise, uv * _WindNoise_ST.xy + _WindNoise_ST.zw * _Time.y);
                wind = (wind - 0.5) * 2 * _WindIntensity;

                if (_UseWindMaskTexture == 1)
                    wind *= _WindIntensity * tex2D(_WindMaskTexture, uv);
                else
                    wind *= _WindIntensity * smoothstep(_WindMaskMin, _WindMaskMax, 1 - i.uv.y);

                uv += wind;
                
                float4 color = tex2D(_MainTex, uv);
                color.rgb *= i.color;
                return color;
            }
            
            ENDCG
        }
    }
}
