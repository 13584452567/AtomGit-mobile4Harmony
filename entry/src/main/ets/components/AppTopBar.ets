import { DisplayMetrics } from '../common/DisplayMetrics';
import { Dimens, FontSize } from './DesignTokens';

export class AppTopBarAction {
  readonly icon: Resource;
  readonly label: string;

  constructor(icon: Resource, label: string) {
    this.icon = icon;
    this.label = label;
  }
}

@ComponentV2
export struct AppTopBar {
  @Param title: string = '';
  @Param subtitle: string = '';
  @Param actions: AppTopBarAction[] = [];
  @Param segments: string[] = [];
  @Param segmentIndex: number = 0;
  @Param scrolled: boolean = false;
  @Param onSegmentSelect: (index: number) => void = (_index: number): void => {};
  @Param onAction: (index: number) => void = (_index: number): void => {};

  @Local metrics: DisplayMetrics = DisplayMetrics.instance();

  static readonly ROW_HEIGHT: number = 56;
  static readonly SEGMENT_HEIGHT: number = 48;

  static totalHeight(hasSegments: boolean): number {
    return hasSegments
      ? AppTopBar.ROW_HEIGHT + AppTopBar.SEGMENT_HEIGHT
      : AppTopBar.ROW_HEIGHT;
  }

  private hairline(): ResourceColor {
    return $r('app.color.ag_card_border');
  }

  @Builder
  actionButton(action: AppTopBarAction, index: number): void {
    Button({ type: ButtonType.Circle }) {
      SymbolGlyph(action.icon)
        .fontSize(20)
        .fontColor([$r('app.color.ag_text_primary')])
    }
    .width(40)
    .height(40)
    .backgroundColor($r('app.color.ag_topbar_glass'))
    .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
    .shadow({
      radius: 8,
      color: $r('app.color.ag_glass_shadow'),
      offsetX: 0,
      offsetY: 2
    })
    .clickEffect({ level: ClickEffectLevel.LIGHT, scale: 0.94 })
    .onClick(() => {
      this.onAction(index);
    })
    .id('topbar_action_' + action.label)
  }

  @Builder
  segmentChip(label: string, index: number): void {
    Text(label)
      .fontSize(FontSize.body)
      .fontWeight(this.segmentIndex === index ? FontWeight.Medium : FontWeight.Regular)
      .fontColor(this.segmentIndex === index
        ? $r('app.color.ag_text_on_accent')
        : $r('app.color.ag_text_secondary'))
      .textAlign(TextAlign.Center)
      .layoutWeight(1)
      .height(36)
      .borderRadius(18)
      .backgroundColor(this.segmentIndex === index
        ? $r('app.color.ag_accent')
        : $r('app.color.ag_topbar_glass'))
      .backgroundBlurStyle(this.segmentIndex === index
        ? BlurStyle.NONE
        : BlurStyle.COMPONENT_THICK)
      .clickEffect({ level: ClickEffectLevel.LIGHT, scale: 0.97 })
      .onClick(() => {
        this.onSegmentSelect(index);
      })
      .id('topbar_segment_' + index)
  }

  build() {
    Column() {
      Row({ space: Dimens.sm }) {
        Column({ space: 2 }) {
          Text(this.title)
            .fontSize(FontSize.headline)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.ag_text_primary'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          if (this.subtitle.length > 0) {
            Text(this.subtitle)
              .fontSize(FontSize.caption)
              .fontColor($r('app.color.ag_text_tertiary'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        ForEach(this.actions, (action: AppTopBarAction, index: number) => {
          this.actionButton(action, index)
        }, (action: AppTopBarAction) => action.label)
      }
      .width('100%')
      .height(AppTopBar.ROW_HEIGHT)
      .padding({ left: Dimens.lg, right: Dimens.lg })

      if (this.segments.length > 0) {
        Row({ space: Dimens.xs }) {
          ForEach(this.segments, (label: string, index: number) => {
            this.segmentChip(label, index)
          }, (label: string) => label)
        }
        .width('100%')
        .height(AppTopBar.SEGMENT_HEIGHT)
        .padding({ left: Dimens.lg, right: Dimens.lg, bottom: Dimens.sm })
      }
    }
    .width('100%')
    .padding({ top: this.metrics.topInsetVp })
    .backgroundColor($r('app.color.ag_topbar_glass'))
    .backgroundBlurStyle(BlurStyle.COMPONENT_THICK, {
      colorMode: ThemeColorMode.SYSTEM,
      adaptiveColor: AdaptiveColor.AVERAGE
    })
    .border({ width: 0.5, color: this.hairline() })
    .shadow({
      radius: this.scrolled ? 12 : 0,
      color: $r('app.color.ag_glass_shadow'),
      offsetX: 0,
      offsetY: this.scrolled ? 4 : 0
    })
  }
}