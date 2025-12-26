//
//  IconPalette.swift
//  DesignSystem
//
//  Created by 김민준 on 12/26/25.
//

import Foundation

public enum IconPalette {
    
    /// 아이콘 인덱스에 일치하는 아이콘 이미지를 반환합니다.
    public static func toIcon(from index: Int) -> String {
        guard index < icons.count else { return icons[0] }
        return icons[index]
    }
    
    /// 선택 가능한 아이콘 팔레트 배열을 반환합니다.
    public static let icons: [String] = objectIcons
    + natureIcons
    + fitnessIcons
    + furnitureIcons
    + etcIcons
    
    /// 사물 아이콘 팔레트 배열을 반환합니다.
    public static let objectIcons = objectSymbols
    
    /// 자연 아이콘 팔레트 배열을 반환합니다.
    public static let natureIcons = natureSymbols
    
    /// 운동 아이콘 팔레트 배열을 반환합니다.
    public static let fitnessIcons = fitnessSymbols
    
    /// 가구 아이콘 팔레트 배열을 반환합니다.
    public static let furnitureIcons = furnitureSymbols
    
    /// 기타 아이콘 팔레트 배열을 반환합니다.
    public static let etcIcons = etcSymbols
}

// MARK: - SFSymbol String
extension IconPalette {
    
    /// 사물 SFSymbol 배열을 반환합니다.
    static let objectSymbols = [
        
        // 블럭
        "batteryblock.fill",
        
        // 공부
        "pencil",
        "eraser.fill",
        "archivebox.fill",
        "list.clipboard.fill",
        "note.text",
        "calendar",
        "book.closed.fill",
        "text.book.closed.fill",
        "character.book.closed.fill",
        "books.vertical.fill",
        "menucard.fill",
        "greetingcard.fill",
        "magazine.fill",
        "newspaper.fill",
        "scroll.fill",
        "bookmark.fill",
        "graduationcap.fill",
        "ruler.fill",
        "backpack.fill",
        
        // 음식
        "mug.fill",
        "wineglass.fill",
        "fork.knife",
        "takeoutbag.and.cup.and.straw.fill",
        "waterbottle.fill",
        "birthday.cake.fill",
        "frying.pan.fill",
        
        // 엔터테인먼트
        "teddybear.fill",
        "gift.fill",
        "theatermasks.fill",
        "theatermask.and.paintbrush.fill",
        "puzzlepiece.extension.fill",
        "puzzlepiece.fill",
        "party.popper.fill",
        
        // 일반 도구
        "beach.umbrella.fill",
        "trash.fill",
        "gym.bag.fill",
        "megaphone.fill",
        "horn.fill",
        "flashlight.off.fill",
        "camera.fill",
        "scissors",
        "paintbrush.fill",
        "paintbrush.pointed.fill",
        "paintpalette.fill",
        "watch.analog",
        "key.horizontal.fill",
        "pin.fill",
        "map.fill",
        "stroller.fill",
        "arcade.stick.console.fill",
        "gamecontroller.fill",
        "alarm.fill",
        "stopwatch.fill",
        "timer.circle.fill",
        "binoculars.fill",
        
        // 공구
        "wrench.adjustable.fill",
        "hammer.fill",
        "screwdriver.fill",
        "eyedropper.halffull",
        
        // 쇼핑
        "bag.fill",
        "basket.fill",
        "handbag.fill",
        "briefcase.fill",
        "case.fill",
        "suitcase.fill",
        "suitcase.rolling.fill",
        "creditcard.fill",
        
        // 의류
        "crown.fill",
        "tshirt.fill",
        "shoe.fill",
        "sunglasses.fill",
        "comb.fill",
        
        // 공
        "soccerball",
        "baseball.fill",
        "basketball.fill",
        "football.fill",
        "hockey.puck.fill",
        "cricket.ball.fill",
        "tennisball.fill",
        "volleyball.fill",
        
        // 운동 도구
        "tennis.racket",
        "skateboard.fill",
        "skis.fill",
        "snowboard.fill",
        "surfboard.fill",
        
        // 음악
        "radio.fill",
        "headphones",
        "pianokeys.inverse",
        "guitars.fill",
        
        // 교통
        "airplane",
        "car.fill",
        "bus.fill",
        "cablecar.fill",
        "lightrail.fill",
        "ferry.fill",
        "sailboat.fill",
        "truck.box.fill",
        "bicycle",
        "scooter",
        "fuelpump.fill",
        
        // 건강
        "medical.thermometer.fill",
        "bandage.fill",
        "syringe.fill",
        "facemask.fill",
        "pill.fill",
        "cross.vial.fill",
        
        // 실험
        "flask.fill",
        "testtube.2",
        
        // 컴퓨터
        "laptopcomputer",
        "folder.fill",
        "tray.fill",
        "externaldrive.fill",
        "archivebox.fill",
        "printer.fill",
        "scanner.fill",
        "apple.terminal.fill",
        "cursorarrow",
        "keyboard.fill",
        
        // 깃발
        "flag.fill",
        "flag.checkered",
        "flag.2.crossed.fill",
        "flag.checkered.2.crossed",
        
        // 주사위
        "die.face.1.fill",
        "die.face.2.fill",
        "die.face.3.fill",
        "die.face.4.fill",
        "die.face.5.fill",
        "die.face.6.fill",
        
        // 기타
        "paperplane.fill",
        "bell.fill",
        "tag.fill",
        "trophy.fill",
        "medal.fill",
        "gearshape.fill",
        "cube.fill"
    ]

    /// 자연 SFSymbol 배열을 반환합니다.
    static let natureSymbols = [
        
        // 날씨
        "globe.americas.fill",
        "sun.max.fill",
        "moon.fill",
        "moon.stars.fill",
        "sparkles",
        "cloud.fill",
        "cloud.rain.fill",
        "cloud.bolt.rain.fill",
        "cloud.snow.fill",
        "cloud.sun.fill",
        "drop.fill",
        "flame.fill",
        "bolt.fill",
        "mountain.2.fill",
        
        // 동물
        "hare.fill",
        "tortoise.fill",
        "dog.fill",
        "cat.fill",
        "lizard.fill",
        "bird.fill",
        "fish.fill",
        
        // 곤충
        "ant.fill",
        "ladybug.fill",
        
        // 기타
        "pawprint.fill",
        "leaf.fill",
        "camera.macro",
        "tree.fill",
        "carrot.fill",
        "fossil.shell.fill"
    ]

    /// 운동 SFSymbol 배열을 반환합니다.
    public static let fitnessSymbols = [
        
        // 맨몸 운동
        "figure.walk",
        "figure.run",
        "figure.cooldown",
        "figure.core.training",
        "figure.cross.training",
        "figure.dance",
        "figure.flexibility",
        "figure.strengthtraining.functional",
        "figure.gymnastics",
        "figure.highintensity.intervaltraining",
        "figure.jumprope",
        "figure.martial.arts",
        "figure.mind.and.body",
        "figure.mixed.cardio",
        "figure.pilates",
        "figure.rolling",
        "figure.rower",
        "figure.socialdance",
        "figure.stairs",
        "figure.step.training",
        "figure.taichi",
        "figure.wrestling",
        "figure.yoga",
        
        // 격투 종목
        "figure.boxing",
        "figure.fencing",
        "figure.kickboxing",
        
        // 하계 종목
        "figure.equestrian.sports",
        "figure.pool.swim",
        "figure.open.water.swim",
        "figure.sailing",
        "figure.water.fitness",
        "figure.waterpolo",
        
        
        // 동계 종목
        "figure.skiing.crosscountry",
        "figure.skiing.downhill",
        "figure.skating",
        "figure.snowboarding",
        "figure.surfing",
        
        // 기타 종목
        "figure.archery",
        "figure.barre",
        "figure.climbing",
        "figure.fishing",
        "figure.hiking",
        "figure.hunting",
        "figure.outdoor.cycle",
        "figure.play",
        "figure.track.and.field",
        "figure.strengthtraining.traditional",
        
        // 구기 종목
        "figure.american.football",
        "figure.australian.football",
        "figure.badminton",
        "figure.baseball",
        "figure.basketball",
        "figure.bowling",
        "figure.cricket",
        "figure.curling",
        "figure.disc.sports",
        "figure.elliptical",
        "figure.golf",
        "figure.handball",
        "figure.hockey",
        "figure.pickleball",
        "figure.racquetball",
        "figure.rugby",
        "figure.soccer",
        "figure.softball",
        "figure.squash",
        "figure.table.tennis",
        "figure.tennis",
        "figure.volleyball"
    ]

    /// 가구 SFSymbol 배열을 반환합니다.
    public static let furnitureSymbols = [
        
        // 집 아이콘
        "house.fill",
        "house.and.flag.fill",
        "tent.fill",
        
        // 문 & 차운
        "door.left.hand.closed",
        "entry.lever.keypad.fill",
        "curtains.closed",
        
        // 에어컨 및 건조기
        "dehumidifier.fill",
        "humidifier.fill",
        "air.purifier.fill",
        "air.conditioner.horizontal.fill",
        
        // 물
        "sprinkler.and.droplets.fill",
        "spigot.fill",
        
        // 가구
        "bed.double.fill",
        "sofa.fill",
        "chair.lounge.fill",
        "chair.fill",
        "cabinet.fill",
        "fireplace.fill",
        "washer.fill",
        "dryer.fill",
        "studentdesk",
        
        // 요리
        "oven.fill",
        "cooktop.fill",
        
        // 선풍기
        "fan.fill",
        "fan.desk.fill",
        "fan.ceiling.fill",
        "refrigerator.fill",
        
        // 화장실
        "shower.fill",
        "shower.handheld.fill",
        "bathtub.fill",
        "sink.fill",
        "toilet.fill",
        
        // 조명
        "lightbulb.fill",
        "lamp.desk.fill",
        "lamp.floor.fill",
        "lamp.ceiling.fill",
        "light.recessed.fill",
        "chandelier.fill",
        "light.beacon.max.fill",
        "av.remote.fill"
    ]
     
    /// 기타 SFSymbol 배열을 반환합니다.
    public static let etcSymbols = [
        
        // 심볼
        "suit.heart.fill",
        "suit.club.fill",
        "suit.diamond.fill",
        "suit.spade.fill",
        "star.fill",
        "staroflife.fill",
        "shield.fill",
        
        
        // 일반 기호
        "questionmark.circle.fill",
        "exclamationmark.circle.fill",
        "wonsign.circle.fill",
        "dollarsign.circle.fill",
        "eurosign.circle.fill",
        "centsign.circle.fill",
        "yensign.circle.fill",
        "sterlingsign.circle.fill",
        "francsign.circle.fill",
        "kipsign.circle.fill",
        
        // 영어
        "a.circle.fill",
        "b.circle.fill",
        "c.circle.fill",
        "d.circle.fill",
        "e.circle.fill",
        "f.circle.fill",
        "g.circle.fill",
        "h.circle.fill",
        "i.circle.fill",
        "j.circle.fill",
        "k.circle.fill",
        "l.circle.fill",
        "m.circle.fill",
        "n.circle.fill",
        "o.circle.fill",
        "p.circle.fill",
        "q.circle.fill",
        "r.circle.fill",
        "s.circle.fill",
        "t.circle.fill",
        "u.circle.fill",
        "v.circle.fill",
        "w.circle.fill",
        "x.circle.fill",
        "y.circle.fill",
        "z.circle.fill",
        
        // 숫자
        "0.circle.fill",
        "1.circle.fill",
        "2.circle.fill",
        "3.circle.fill",
        "4.circle.fill",
        "5.circle.fill",
        "6.circle.fill",
        "7.circle.fill",
        "8.circle.fill",
        "9.circle.fill"
    ]
}
