#pragma once
#include "Types.cuh"

namespace cuNSearch
{
	struct GridInfo
	{
		cuNSearch::Real3 GridMin;
		uint ParticleCount;
		cuNSearch::Real3 GridDelta;
		UInt3 GridDimension;
		UInt3 MetaGridDimension;
		float SquaredSearchRadius;
	};
}
