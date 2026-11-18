// Fold the sidebar to its rail / unfold it with a slide (layout.resize in steps), same rule as the
// shipped toggleSidebar(). Opened by ctrl-shift-b and by the sidebar buttons of the *-anim mods.
// Bound as "mod.open:sidebar-anim" (an invisible 1px overlay that animates and closes itself).
import { View, div } from "gpui-kit";
import { layout, run, props, closeOverlay, shared, setShared } from "herdr";

const ID = "sidebar";
const MIN = 44;        // the narrowest the sidebar can be (rail)
const MS = 420;        // duration
const STEP = 16;       // ms per frame

function find(node, id) {
  if (!node || typeof node !== "object") return null;
  if (node.id === id) return node;
  for (const c of node.children ?? []) { const r = find(c, id); if (r) return r; }
  return null;
}
const ease = (t) => (t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2);   // ease-in-out cubic

export default class SidebarAnim extends View {
  init(_props, cx) {
    const cur = find(layout(), ID)?.size?.px ?? 268;
    const narrow = cur < 160;
    if (!narrow) setShared("sidebar.width", cur);
    setShared("sidebar.collapsed", !narrow);
    const to = narrow ? (shared("sidebar.width") ?? 268) : MIN;
    // unfolding: wide look from the first frame; folding: rail look only once it has folded
    setShared("sidebar.anim", "wide");
    cx.spawn(async (cx) => {
      try {
        const t0 = Date.now();
        let last = cur;
        for (;;) {
          const k = Math.min(1, (Date.now() - t0) / MS);   // by clock, so a slow frame doesn't stretch the slide
          const px = Math.round(cur + (to - cur) * ease(k));
          if (px !== last) { run("layout.resize", { id: ID, px }); last = px; }
          if (k >= 1) break;
          await cx.sleep(4);
        }
      } finally {
        setShared("sidebar.anim", "");   // back to going by width (44 -> rail look)
        closeOverlay(props().overlay);
      }
    });
  }

  render(_cx) {
    return div().size(1);
  }
}
