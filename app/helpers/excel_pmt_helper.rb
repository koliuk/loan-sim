module ExcelPmtHelper    
    def self.pmt(rate, nper, pv, fv=0, type=0)
        ((-pv * self.pvif(rate, nper) - fv ) / ((1.0 + rate * type) * self.fvifa(rate, nper)))
    end

    def self.ipmt(rate, per, nper, pv, fv=0, type=0)
        p = self.pmt(rate, nper, pv, fv, 0);
        ip = -(pv * self.pow1p(rate, per - 1) * rate + p * self.pow1pm1(rate, per - 1))
        (type == 0) ? ip : ip / (1 + rate)
    end

    def self.ppmt(rate, per, nper, pv, fv=0, type=0)
     p = self.pmt(rate, nper, pv, fv, type)
     ip = self.ipmt(rate, per, nper, pv, fv, type)
     p - ip
    end
    
    protected
    
    def self.pow1pm1(x, y)
        (x <= -1) ? ((1 + x) ** y) - 1 : Math.exp(y * Math.log(1.0 + x)) - 1
    end

    def self.pow1p(x, y)
        (x.abs > 0.5) ? ((1 + x) ** y) : Math.exp(y * Math.log(1.0 + x))
    end

    def self.pvif(rate, nper)
        self.pow1p(rate, nper)
    end

    def self.fvifa(rate, nper)
        (rate == 0) ? nper : self.pow1pm1(rate, nper) / rate
    end
    
end