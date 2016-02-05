#pragma once

namespace support_at {
    class Point2D_d {
    public:
	Point2D_d(double x, double y);
	inline double& x() { return m_x; }
	inline double& y() { return m_y; }
	double m_x;
	double m_y;
    };
}
