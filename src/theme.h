#pragma once

#include <QColor>
#include <QFileSystemWatcher>
#include <QObject>
#include <QString>

class Theme : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString themeMode READ themeMode WRITE setThemeMode NOTIFY themeModeChanged)
    Q_PROPERTY(QString mode READ mode NOTIFY changed)
    Q_PROPERTY(bool isDark READ isDark NOTIFY changed)
    Q_PROPERTY(QColor accent READ accent NOTIFY changed)
    Q_PROPERTY(QColor onAccent READ onAccent NOTIFY changed)
    Q_PROPERTY(QColor selection READ selection NOTIFY changed)
    Q_PROPERTY(QColor muted READ muted NOTIFY changed)
    Q_PROPERTY(QColor background READ background NOTIFY changed)
    Q_PROPERTY(QColor darkBackground READ darkBackground NOTIFY changed)
    Q_PROPERTY(QColor darkerBackground READ darkerBackground NOTIFY changed)
    Q_PROPERTY(QColor lighterBackground READ lighterBackground NOTIFY changed)
    Q_PROPERTY(QColor foreground READ foreground NOTIFY changed)
    Q_PROPERTY(QColor darkForeground READ darkForeground NOTIFY changed)
    Q_PROPERTY(QColor lightForeground READ lightForeground NOTIFY changed)
    Q_PROPERTY(QColor brightForeground READ brightForeground NOTIFY changed)
    Q_PROPERTY(QColor incomingBubble READ incomingBubble NOTIFY changed)
    Q_PROPERTY(QColor incomingBubbleBorder READ incomingBubbleBorder NOTIFY changed)
    Q_PROPERTY(QColor outgoingBlueBubble READ outgoingBlueBubble NOTIFY changed)
    Q_PROPERTY(QColor outgoingBlueBorder READ outgoingBlueBorder NOTIFY changed)
    Q_PROPERTY(QColor outgoingGreenBubble READ outgoingGreenBubble NOTIFY changed)
    Q_PROPERTY(QColor outgoingGreenBorder READ outgoingGreenBorder NOTIFY changed)
    Q_PROPERTY(QColor subtleSurface READ subtleSurface NOTIFY changed)
    Q_PROPERTY(QColor subtleBorder READ subtleBorder NOTIFY changed)
    Q_PROPERTY(QColor overlayBackground READ overlayBackground NOTIFY changed)
    Q_PROPERTY(QColor modalScrim READ modalScrim NOTIFY changed)
    Q_PROPERTY(QColor invisibleInkIncoming READ invisibleInkIncoming NOTIFY changed)
    Q_PROPERTY(QColor red READ red NOTIFY changed)
    Q_PROPERTY(QColor yellow READ yellow NOTIFY changed)
    Q_PROPERTY(QColor orange READ orange NOTIFY changed)
    Q_PROPERTY(QColor green READ green NOTIFY changed)
    Q_PROPERTY(QColor cyan READ cyan NOTIFY changed)
    Q_PROPERTY(QColor blue READ blue NOTIFY changed)
    Q_PROPERTY(QColor magenta READ magenta NOTIFY changed)
    Q_PROPERTY(int radius READ radius NOTIFY changed)
    Q_PROPERTY(int fontSize READ fontSize NOTIFY changed)

public:
    explicit Theme(QObject *parent = nullptr);

    static QString normalizeThemeMode(const QString &mode);

    QString themeMode() const { return m_themeMode; }
    Q_INVOKABLE void setThemeMode(const QString &mode);

    QString mode() const { return m_mode; }
    bool isDark() const { return m_mode.compare(QStringLiteral("light"), Qt::CaseInsensitive) != 0; }
    QColor accent() const { return m_accent; }
    QColor onAccent() const { return m_onAccent; }
    QColor selection() const { return m_selection; }
    QColor muted() const { return m_muted; }
    QColor background() const { return m_background; }
    QColor darkBackground() const { return m_darkBackground; }
    QColor darkerBackground() const { return m_darkerBackground; }
    QColor lighterBackground() const { return m_lighterBackground; }
    QColor foreground() const { return m_foreground; }
    QColor darkForeground() const { return m_darkForeground; }
    QColor lightForeground() const { return m_lightForeground; }
    QColor brightForeground() const { return m_brightForeground; }
    QColor incomingBubble() const { return m_incomingBubble; }
    QColor incomingBubbleBorder() const { return m_incomingBubbleBorder; }
    QColor outgoingBlueBubble() const { return m_outgoingBlueBubble; }
    QColor outgoingBlueBorder() const { return m_outgoingBlueBorder; }
    QColor outgoingGreenBubble() const { return m_outgoingGreenBubble; }
    QColor outgoingGreenBorder() const { return m_outgoingGreenBorder; }
    QColor subtleSurface() const { return m_subtleSurface; }
    QColor subtleBorder() const { return m_subtleBorder; }
    QColor overlayBackground() const { return m_overlayBackground; }
    QColor modalScrim() const { return m_modalScrim; }
    QColor invisibleInkIncoming() const { return m_invisibleInkIncoming; }
    QColor red() const { return m_red; }
    QColor yellow() const { return m_yellow; }
    QColor orange() const { return m_orange; }
    QColor green() const { return m_green; }
    QColor cyan() const { return m_cyan; }
    QColor blue() const { return m_blue; }
    QColor magenta() const { return m_magenta; }
    int radius() const { return m_radius; }
    int fontSize() const { return m_fontSize; }

    Q_INVOKABLE void reload();
    void loadFromTomlString(const QString &tomlContent);

    void setSystemColorSchemeForTest(bool isLight);
    void clearSystemColorSchemeOverrideForTest();

signals:
    void changed();
    void themeModeChanged();

private:
    void setupWatcher();
    bool detectSystemIsLight() const;
    void applyDefaultDarkPalette();
    void applyDefaultLightPalette();
    void applySemanticPaletteForMode(bool isLight);

    QFileSystemWatcher m_watcher;
    QString m_themeMode = QStringLiteral("system");
    bool m_hasSystemColorSchemeOverrideForTest = false;
    bool m_systemColorSchemeOverrideIsLightForTest = false;
    QString m_mode = QStringLiteral("dark");
    QColor m_accent = QColor(QStringLiteral("#7aa2f7"));
    QColor m_onAccent = QColor(QStringLiteral("#0e0e14"));
    QColor m_selection = QColor(QStringLiteral("#292e42"));
    QColor m_muted = QColor(QStringLiteral("#414868"));
    QColor m_background = QColor(QStringLiteral("#1a1b26"));
    QColor m_darkBackground = QColor(QStringLiteral("#13141c"));
    QColor m_darkerBackground = QColor(QStringLiteral("#0e0e14"));
    QColor m_lighterBackground = QColor(QStringLiteral("#24283b"));
    QColor m_foreground = QColor(QStringLiteral("#a9b1d6"));
    QColor m_darkForeground = QColor(QStringLiteral("#565f89"));
    QColor m_lightForeground = QColor(QStringLiteral("#b4bee6"));
    QColor m_brightForeground = QColor(QStringLiteral("#c0caf5"));
    QColor m_incomingBubble = QColor(QStringLiteral("#1e2430"));
    QColor m_incomingBubbleBorder = QColor(QStringLiteral("#2c3545"));
    QColor m_outgoingBlueBubble = QColor(QStringLiteral("#0A84FF"));
    QColor m_outgoingBlueBorder = QColor(QStringLiteral("#0066CC"));
    QColor m_outgoingGreenBubble = QColor(QStringLiteral("#1B6E38"));
    QColor m_outgoingGreenBorder = QColor(QStringLiteral("#268C48"));
    QColor m_subtleSurface = QColor(255, 255, 255, 13);
    QColor m_subtleBorder = QColor(255, 255, 255, 26);
    QColor m_overlayBackground = QColor(QStringLiteral("#cc131620"));
    QColor m_modalScrim = QColor(QStringLiteral("#aa0e0e14"));
    QColor m_invisibleInkIncoming = QColor(QStringLiteral("#252d3d"));
    QColor m_red = QColor(QStringLiteral("#f7768e"));
    QColor m_yellow = QColor(QStringLiteral("#e0af68"));
    QColor m_orange = QColor(QStringLiteral("#eb927b"));
    QColor m_green = QColor(QStringLiteral("#9ece6a"));
    QColor m_cyan = QColor(QStringLiteral("#449dab"));
    QColor m_blue = QColor(QStringLiteral("#7aa2f7"));
    QColor m_magenta = QColor(QStringLiteral("#ad8ee6"));
    int m_radius = 10;
    int m_fontSize = 15;
};
