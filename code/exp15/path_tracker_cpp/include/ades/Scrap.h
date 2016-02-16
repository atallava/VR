#pragma once

namespace ades {
    class Scrap {
    public:
	Scrap();
	inline double& x() { return m_x; }
	inline double& y() { return m_y; }
	double m_x;
	double m_y;
    };
}
