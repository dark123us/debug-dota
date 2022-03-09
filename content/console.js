(function (global) {
    const log = (...msgs) => {
        let sep = '';
        if (!(msgs instanceof Array)) msgs = [msgs]
        const msg = msgs.reduce((prev, cur) => {
            const v = (cur instanceof Error)?'('+cur.name+') '+cur.message:
                (typeof cur == "array" || typeof cur == "object")?
                    JSON.stringify(cur):  cur;
            const res = prev + sep + v;
            sep = ' ';
            return res;
        }, '');
        $.Msg(msg);
    };

    const NAME = "console"
    const UNIT = {[NAME]: {log}}
    if (typeof define === "function" && define.amd) {
        define(UNIT[NAME]);
    } else if (typeof module !== "undefined" && module.exports) {
        module.exports = UNIT[NAME];
    } else {
        const prev = '_prev' + NAME
        UNIT[NAME][prev] = global[NAME];
        UNIT[NAME].noConflict = function () {
            global[NAME] = UNIT[NAME][prev];
            return UNIT[NAME];
        };
        global[NAME] = UNIT[NAME];
    }
})(this)

