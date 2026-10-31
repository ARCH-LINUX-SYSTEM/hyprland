import { View, div, image, svg } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { theme, run, props, window, shared, setShared, updates, layout, home, readTextFile, watchFolder } from "herdr";

function find(node, id) {
  if (node?.id === id) return node;
  for (const child of node?.children ?? []) {
    const found = find(child, id);
    if (found) return found;
  }
  return null;
}

// The sidebar's rail goes by its width, not a flag: dragging its edge narrows it too.
// While sidebar-anim slides, the rail/wide look switches once (at the end when folding, at the start
// when unfolding) instead of at 160px mid-slide; otherwise it goes by width (dragging narrows it too).
const narrow = () => { const a = shared("sidebar.anim"); return a ? a === "rail" : (find(layout(), "sidebar")?.size?.px ?? Infinity) < 160; };

// To the rail (on macOS wide enough for the traffic lights), or back to the width it had.
function toggleSidebar() {
  run("mod.open", { name: "sidebar-anim" });   // slide animation (mods/sidebar-anim)
}

export default class WorkspaceChrome extends View {
  button(id, label, action) {
    const t = theme();
    return div().id(id).size(26).flex_none().flex().items_center().justify_center().rounded(6).text_color(t.muted).hover(s => s.bg(t.hover).text_color(t.foreground))
      .on_mouse_down("left", (_e, cx) => cx.stop_propagation()).on_click(action).child(label);
  }
  // Ctrl/Shift/Alt held right now: ~/.local/bin/cael-modkeys (evdev) writes them to ~/.local/state/cael-mods/mods
  init(_props, cx) {
    this.mods = [];
    const dir = home() + "/.local/state/cael-mods";
    const load = async () => { this.mods = ((await readTextFile(dir + "/mods")) ?? "").trim().split(",").filter(Boolean); };
    cx.spawn(async (cx) => {
      await load(); cx.notify();
      for (;;) { await watchFolder(dir); await load(); cx.notify(); }
    });
  }

  pill(t, name) {
    const on = (this.mods ?? []).includes(name.toLowerCase());
    return div().px(5).py(1).rounded(4).text_size(10.5).font_semibold().flex_none()
      .bg(on ? t.accent : t.hover).text_color(on ? t.surface : t.dim).child(name);
  }

  render() {
    const t = theme();
    const collapsed = narrow();
    if (props()?.footer) {
      const row = (id, icon, label, dim, action) => h_flex().id(id).h(28).px(8).gap(9).items_center().rounded(8)
        .text_color(dim ? t.dim : t.muted).hover(s => s.bg(t.hover).text_color(t.foreground)).cursor_pointer()
        .on_click(action).child(svg(`mods/workspace-chrome-anim/${icon}.svg`).size(14))
        .when(!collapsed, el => el.child(label));
      return v_flex().size_full().bg(t.chrome).border_t(1).border_color(t.border).px(8).pt(4).pb(8).text_size(13)
        .child(row("settings", "settings", "Settings", false, () => run("app.settings"))
          .when(Boolean(updates().app.ready), el => el.child(div().size(6).rounded_full().bg(t.accent)))
          .when(!collapsed, el => el.child(div().flex_1()).child(h_flex().gap(3).items_center()
            .child(this.pill(t, "Ctrl")).child(this.pill(t, "Shift")).child(this.pill(t, "Alt")))))
        .child(row("machine", "plus", "Add machine", true, () => run("mod.open", { name: "machine-add" })));
    }
    return h_flex().size_full().bg(t.chrome).pl(collapsed ? 6 : 14).pr(10).gap(4).items_center().text_size(13.5)
      .when(window()?.platform === "macos" && !collapsed, el => el.pl(76))
      .when(!collapsed, el => el.child(h_flex().flex_1().gap(8).items_center().child(image("frame/welcome/herdr.png").size(20).rounded(5)).child(div().font_semibold().text_color(t.foreground).child("Herdr"))))
      .when(!collapsed, el => el.child(this.button("search", svg("mods/workspace-chrome-anim/search.svg").size(15), () => run("mod.open", { name: "picker" }))))
      // On the macOS rail the traffic lights fill the row; the agents list's » unfolds it.
      .when(!(collapsed && window()?.platform === "macos"), el => el.child(this.button("sidebar-toggle", svg("mods/workspace-chrome-anim/sidebar.svg").size(15), toggleSidebar)));
  }
}
