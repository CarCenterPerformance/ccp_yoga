Config = {}

-- NPC
Config.NPC = {
    model = 'a_f_y_yoga_01',
    coords = vector4(-1493.18, 829.27, 181.62, 45.0)
}

-- Blip
Config.Blip = {
    enabled = true,
    sprite = 197,
    color = 2,
    scale = 0.8,
    name = 'Yoga'
}

-- Yoga Einstellungen
Config.Yoga = {
    startDelay = 10, -- Sekunden bis Yoga startet
    durationText = 'Drücke X um Yoga zu beenden',
    animation = {
        dict = 'amb@world_human_yoga@female@base',
        name = 'base_a'
    }
}

-- Taste
Config.Keys = {
    interact = 38, -- E
    cancel = 73 -- X
}
